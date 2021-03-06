implementation module iTasks.WF.Tasks.IO

import iTasks.Internal.SDS
import iTasks.Internal.Util
import iTasks.SDS.Combinators.Common
import iTasks.SDS.Definition
import iTasks.WF.Definition
import iTasks.UI.Definition
import iTasks.UI.Editor
import iTasks.UI.Prompt

import iTasks.Internal.IWorld
import iTasks.Internal.Task
import iTasks.Internal.TaskState
import iTasks.Internal.TaskEval
import iTasks.Internal.TaskServer
import iTasks.Internal.Generic.Visualization
import iTasks.Internal.Generic.Defaults

import System.Process
import Text, Text.GenJSON, StdString, StdInt, StdBool, StdList, StdTuple, Data.Tuple, Data.Func, StdFunc
import qualified Data.Map as DM
import qualified Data.Set as DS

:: ExitCode = ExitCode !Int
:: ExternalProcessHandlers l r w =
    { onStartup     :: !(           r -> (!MaybeErrorString l, !Maybe w, ![String], !Bool))
    , onOutData     :: !(String   l r -> (!MaybeErrorString l, !Maybe w, ![String], !Bool))
    , onErrData     :: !(String   l r -> (!MaybeErrorString l, !Maybe w, ![String], !Bool))
    , onShareChange :: !(         l r -> (!MaybeErrorString l, !Maybe w, ![String], !Bool))
    , onExit        :: !(ExitCode l r -> (!MaybeErrorString l, !Maybe w                  ))
    }

derive JSONEncode ProcessHandle, ProcessIO
derive JSONDecode ProcessHandle, ProcessIO

liftOSErr f iw = case (liftIWorld f) iw of
	(Error (_, e), iw) = (Error (exception e), iw)
	(Ok a, iw) = (Ok a, iw)

externalProcess :: !Timespec !FilePath ![String] !(Maybe FilePath) !(Maybe ProcessPtyOptions) !(Shared sds1 [String]) !(Shared sds2 ([String], [String])) -> Task Int | RWShared sds1 & RWShared sds2
externalProcess poll cmd args dir mopts sdsin sdsout = Task eval
where
	fjson = mb2error (exception "Corrupt taskstate") o fromDeferredJSON

	eval :: Event TaskEvalOpts TaskTree *IWorld -> *(TaskResult Int, *IWorld)

	//Destroyed while the process was still running
	eval DestroyEvent evalOpts (TCBasic taskId ts jsonph _) iworld
		# iworld = clearTaskSDSRegistrations ('DS'.singleton taskId) iworld
		= apIWTransformer iworld
		$             tuple (fjson jsonph)
		>-= \(ph, _)->liftOSErr (terminateProcess ph)
		>-= \_      ->tuple (Ok DestroyedResult)

	//Destroyed when the task was already stable
	eval DestroyEvent evalOpts tree iworld
		# iworld = clearTaskSDSRegistrations ('DS'.singleton $ fromOk $ taskIdFromTaskTree tree) iworld
		= (DestroyedResult, iworld)


	eval event evalOpts tree=:(TCInit taskId ts) iworld
		= case liftOSErr (maybe (runProcessIO cmd args dir) (runProcessPty cmd args dir) mopts) iworld of
			(Error e, iworld) = (ExceptionResult e, iworld)
			(Ok ph, iworld) = eval event evalOpts (TCBasic taskId ts (DeferredJSON ph) False) iworld

	eval event evalOpts tree=:(TCBasic taskId ts jsonph _) iworld
		= apIWTransformer iworld $
			tuple (fjson jsonph)                        >-= \(ph, pio)->
			read sdsout EmptyContext                    >-= \(ReadingDone (stdoutq, stderrq))->
			liftOSErr (readPipeNonBlocking pio.stdOut)  >-= \stdoutData->
			liftOSErr (readPipeNonBlocking pio.stdErr)  >-= \stderrData->
			(if (stdoutData == "" && stderrData == "")
				(tuple (Ok WritingDone))
				(write (stdoutq ++ filter ((<>)"") [stdoutData]
				       ,stderrq ++ filter ((<>)"") [stderrData]
				       ) sdsout EmptyContext))          >-= \WritingDone->
			liftOSErr (checkProcess ph)                 >-= \mexitcode->case mexitcode of
				(Just i) = tuple (Ok (ValueResult (Value i True) (info ts) (rep event) (TCStable taskId ts (DeferredJSONNode (JSONInt i)))))
				Nothing =
					readRegister taskId clock                            >-= \_->
					readRegister taskId sdsin                            >-= \(ReadingDone stdinq)->
					liftOSErr (writePipe (concat stdinq) pio.stdIn)      >-= \_->
					(if (stdinq =: []) (tuple (Ok WritingDone)) (write [] sdsin EmptyContext)) >-= \WritingDone ->
					tuple (Ok (ValueResult NoValue (info ts) (rep event) tree))

	//Stable
	eval event evalOpts tree=:(TCStable tid ts (DeferredJSONNode (JSONInt i))) iworld
		= (ValueResult (Value i True) (info ts) (rep event) tree, iworld)

	info ts = {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]}

	rep ResetEvent = ReplaceUI (stringDisplay ("External process: " <+++ cmd))
	rep _ = NoChange

	clock = sdsFocus {start=zero,interval=poll} iworldTimespec

tcplisten :: !Int !Bool !(sds () r w) (ConnectionHandlers l r w) -> Task [l] | iTask l & iTask r & iTask w & RWShared sds
tcplisten port removeClosed sds handlers = Task eval
where
    eval DestroyEvent evalOpts tree=:(TCBasic taskId ts _ _) iworld=:{ioStates}
        # ioStates = case 'DM'.get taskId ioStates of
            Just (IOActive values)  = 'DM'.put taskId (IODestroyed values) ioStates
            _                       = ioStates
        = (DestroyedResult,{iworld & ioStates = ioStates})

    //Destroyed before a connection has been made
    eval DestroyEvent evalOpts tree iworld
        = (DestroyedResult, iworld)

	eval event evalOpts tree=:(TCInit taskId ts) iworld
        = case addListener taskId port removeClosed (wrapConnectionTask handlers sds) iworld of
            (Error e,iworld)
                = (ExceptionResult e, iworld)
            (Ok _,iworld)
                = (ValueResult (Value [] False) {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} (rep port)
                                                    (TCBasic taskId ts (DeferredJSONNode JSONNull) False),iworld)

    eval event evalOpts tree=:(TCBasic taskId ts _ _) iworld=:{ioStates}
        = case 'DM'.get taskId ioStates of
            Just (IOException e)
                = (ExceptionResult (exception e), iworld)
            Just (IOActive values)
                # value = Value [l \\ (_,(l :: l^,_)) <- 'DM'.toList values] False
                = (ValueResult value {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} (rep port) (TCBasic taskId ts (DeferredJSONNode JSONNull) False),iworld)
            Nothing
                = (ValueResult (Value [] False) {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} (rep port) (TCBasic taskId ts (DeferredJSONNode JSONNull) False), iworld)

    rep port = ReplaceUI (stringDisplay ("Listening for connections on port "<+++ port))

tcpconnect :: !String !Int !(sds () r w) (ConnectionHandlers l r w) -> Task l | iTask l & iTask r & iTask w & RWShared sds
tcpconnect host port sds handlers = Task eval
where
    eval DestroyEvent evalOpts tree=:(TCBasic taskId ts _ _) iworld=:{ioStates}
        # ioStates = case 'DM'.get taskId ioStates of
            Just (IOActive values)  = 'DM'.put taskId (IODestroyed values) ioStates
            _                       = ioStates
        = (DestroyedResult,{iworld & ioStates = ioStates})

    eval DestroyEvent evalOpts tree=:(TCInit taskId ts) iworld=:{ioStates}
		# ioStates = case 'DM'.get taskId ioStates of
            Just (IOActive values)  = 'DM'.put taskId (IODestroyed values) ioStates
            _                       = ioStates
        = (DestroyedResult,{iworld & ioStates = ioStates})

	eval event evalOpts tree=:(TCInit taskId ts) iworld=:{IWorld|ioTasks={done,todo},ioStates,world}
        = case addConnection taskId host port (wrapConnectionTask handlers sds) iworld of
            (Error e,iworld)
                = (ExceptionResult e, iworld)
            (Ok _,iworld)
                = (ValueResult NoValue {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} rep (TCBasic taskId ts (DeferredJSONNode JSONNull) False),iworld)

    eval event evalOpts tree=:(TCBasic taskId ts _ _) iworld=:{ioStates}
        = case 'DM'.get taskId ioStates of
            Nothing
                = (ValueResult NoValue {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} rep tree, iworld)
            Just (IOActive values)
                = case 'DM'.get 0 values of
                    Just (l :: l^, s)
                        = (ValueResult (Value l s) {TaskEvalInfo|lastEvent=ts,attributes='DM'.newMap,removedTasks=[]} rep tree, iworld)
                    _
                        = (ExceptionResult (exception "Corrupt IO task result"),iworld)
            Just (IOException e)
                = (ExceptionResult (exception e),iworld)

    rep = ReplaceUI (stringDisplay ("TCP client " <+++ host <+++ ":" <+++ port))

derive JSONEncode Event, Set
