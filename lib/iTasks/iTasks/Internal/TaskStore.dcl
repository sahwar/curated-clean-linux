definition module iTasks.Internal.TaskStore
/**
* This module provides storage of task instances
* It contains two types of task instances:
* Session instances: temporary tasks for each interactive session between a user and the server.
* Workflow instances: persistent long-running tasks that may be shared between users and exist between sessions.
*/

import iTasks.Internal.Task, iTasks.Internal.TaskState, iTasks.UI.Definition, iTasks.Internal.SDS
import iTasks.WF.Combinators.Core
import iTasks.Extensions.Document
import Data.GenEq

from Data.Maybe     import :: Maybe
from Data.Error     import :: MaybeError
from Data.Queue 	import :: Queue
from System.Time    import :: Timestamp

:: InstanceFilter =
	{ //'Vertical' filters
	  onlyInstanceNo    :: !Maybe [InstanceNo]
	, notInstanceNo     :: !Maybe [InstanceNo]
	, includeSessions   :: !Bool
	, includeDetached   :: !Bool
	, includeStartup    :: !Bool
	, matchAttribute 	:: !Maybe (!String,!String)
	  //'Horizontal' filters
	, includeConstants  :: !Bool
	, includeProgress   :: !Bool
	, includeAttributes :: !Bool
	}

:: InstanceData :== (!InstanceNo,!Maybe InstanceConstants,!Maybe InstanceProgress,!Maybe TaskAttributes)

derive class iTask InstanceFilter

//Fresh identifier generation
newInstanceNo           :: !*IWorld -> (!MaybeError TaskException InstanceNo,!*IWorld)
newInstanceKey          :: !*IWorld -> (!InstanceKey,!*IWorld)
newDocumentId			:: !*IWorld -> (!DocumentId, !*IWorld)

//=== Task instance index: ===

//A global index of all task instances is maintained

//This counter is used to ensure unique instance numbers
nextInstanceNo :: SimpleSDSLens Int

//This index contains all meta-data about the task instances on this engine
taskInstanceIndex :: SimpleSDSLens [TIMeta]

//Task instance state is accessible as shared data sources
filteredInstanceIndex   :: SDSLens InstanceFilter [InstanceData] [InstanceData]

//Filtered views on the instance index
taskInstance            :: SDSLens InstanceNo InstanceData InstanceData
taskInstanceConstants   :: SDSLens InstanceNo InstanceConstants ()
taskInstanceProgress    :: SDSLens InstanceNo InstanceProgress InstanceProgress
taskInstanceAttributes  :: SDSLens InstanceNo TaskAttributes TaskAttributes

// === Evaluation state of instances: ===
taskInstanceReduct            :: SDSLens InstanceNo (Maybe TIReduct) (Maybe TIReduct)
taskInstanceValue             :: SDSLens InstanceNo (Maybe TIValue) (Maybe TIValue)
taskInstanceShares            :: SDSLens InstanceNo (Maybe (Map TaskId DeferredJSON)) (Maybe (Map TaskId DeferredJSON))
taskInstanceParallelTaskLists :: SDSLens InstanceNo (Maybe (Map TaskId [ParallelTaskState])) (Maybe (Map TaskId [ParallelTaskState]))

topLevelTaskList        :: SDSLens TaskListFilter (!TaskId,![TaskListItem a]) [(!TaskId,!TaskAttributes)]

taskInstanceIO 			:: SDSLens InstanceNo (Maybe (!String,!Timespec)) (Maybe (!String,!Timespec))
allInstanceIO           :: SimpleSDSLens (Map InstanceNo (!String,Timespec))

//=== Task instance input: ===

//When events are placed in this queue, the engine will re-evaluate the corresponding task instances.
taskEvents :: SimpleSDSLens (Queue (InstanceNo,Event))

//Filtered views on evaluation state of instances:

//Shared source
localShare              			:: SDSLens TaskId a a | iTask a

//Core parallel task list state structure
taskInstanceParallelTaskList        :: SDSLens (TaskId,TaskListFilter) [ParallelTaskState] [ParallelTaskState]

//Private interface used during evaluation of parallel combinator
taskInstanceParallelTaskListItem    :: SDSLens (TaskId,TaskId,Bool) ParallelTaskState ParallelTaskState

taskInstanceEmbeddedTask            :: SDSLens TaskId (Task a) (Task a) | iTask a

//Public interface used by parallel tasks
parallelTaskList                    :: SDSSequence (!TaskId,!TaskId,!TaskListFilter) (!TaskId,![TaskListItem a]) [(!TaskId,!TaskAttributes)] | iTask a

//===  Task instance output: ===

//When task instances are evaluated, their output consists of instructions to modify the user interface
//of that instance to reflect the instance's new state

:: TaskOutputMessage
	= TOUIChange !UIChange
	| TOException !String
	| TODetach !InstanceNo

derive gEq TaskOutputMessage

:: TaskOutput :== Queue TaskOutputMessage

taskOutput          :: SimpleSDSLens (Map InstanceNo TaskOutput)
taskInstanceOutput	:: SDSLens InstanceNo TaskOutput TaskOutput

//=== Access functions: ===


createClientTaskInstance :: !(Task a) !String !InstanceNo !*IWorld -> *(!MaybeError TaskException TaskId, !*IWorld) |  iTask a

createStartupTaskInstance :: !(Task a) !TaskAttributes !*IWorld -> (!MaybeError TaskException InstanceNo, !*IWorld) | iTask a

createSessionTaskInstance :: !(Task a) !TaskAttributes !*IWorld -> (!MaybeError TaskException (!InstanceNo,InstanceKey),!*IWorld) | iTask a

/**
* Create a stored task instance in the task store (lazily without evaluating it)
* @param The task to store
* @param Whether it is a top-level task
* @param The task evaluation options
* @param The instance number for the task
* @param Management meta data
* @param The parallel task list to which the task belongs
* @param If the instance needs to be evaluated immediately, the attachment is temporarily set to the issuer
* @param The IWorld state
*
* @return The task id of the stored instance
* @return The IWorld state
*/
createDetachedTaskInstance :: !(Task a) !Bool !TaskEvalOpts !InstanceNo !TaskAttributes !TaskId !Bool !*IWorld -> (!MaybeError TaskException TaskId, !*IWorld) | iTask a

/**
* Replace a stored task instance in the task store.
* The execution state is reset, but the meta-data is kept.
* @param The instance id
* @param The new task to store
*
* @param The IWorld state
*/
replaceTaskInstance :: !InstanceNo !(Task a) *IWorld -> (!MaybeError TaskException (), !*IWorld) | iTask a

deleteTaskInstance	:: !InstanceNo !*IWorld -> *(!MaybeError TaskException (), !*IWorld)

/**
* Queue an event for a task instance
* events are applied in FIFO order when the task instance is evaluated
*
* By splitting up event queuing and instance evaluation, events can come in asynchronously without
* the need to directly processing them.
*/
queueEvent :: !InstanceNo !Event !*IWorld -> *IWorld

/**
* Convenience function for queueing multiple refresh multiple refresh events at once
*/
queueRefresh :: ![(!TaskId, !String)] !*IWorld -> *IWorld

/**
* Dequeue a task event
*/
dequeueEvent :: !*IWorld -> (!Maybe (InstanceNo,Event),!*IWorld)

/**
* Queue ui change task output
*/
queueUIChange :: !InstanceNo !UIChange !*IWorld -> *IWorld
/**
* Convenience function that queues multiple changes at once
*/
queueUIChanges :: !InstanceNo ![UIChange] !*IWorld -> *IWorld
/**
* Queue exception change task output
*/
queueException :: !InstanceNo !String !*IWorld -> *IWorld

/**
* When a new viewport is attached to an instance, all events and output are removed
* and a single Reset event is queued
*/
attachViewport :: !InstanceNo !*IWorld -> *IWorld

/**
* When a new viewport is detached from an instance, all events and output are removed
*/
detachViewport :: !InstanceNo !*IWorld -> *IWorld

//Documents
createDocument 			:: !String !String !String !*IWorld -> (!MaybeError FileError Document, !*IWorld)
loadDocumentContent		:: !DocumentId !*IWorld -> (!Maybe String, !*IWorld)
loadDocumentMeta		:: !DocumentId !*IWorld -> (!Maybe Document, !*IWorld)
documentLocation		:: !DocumentId !*IWorld -> (!FilePath,!*IWorld)
