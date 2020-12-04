extends Node2D

signal say_dialogue(text)
export (String, FILE) var dialoguePath: String
var loadedDialogue
var button0Branch
var button1Branch
var currentBranch


func _ready():
	loadedDialogue = loadDialogue()
	currentBranch = loadedDialogue["00"]
	sayCurrentBranch()
	$BranchButton0.connect("button_up", self, "onBranchButton0ButtonUp")
	$BranchButton1.connect("button_up", self, "onBranchButton1ButtonUp")
	$NoBranchButton.connect("button_up", self, "onNoBranchButtonUp")

func onBranchButton0ButtonUp() -> void:
	if currentBranch["exitDialogue0"]:
		exitDialogue()
		return
	currentBranch = button0Branch
	sayCurrentBranch()


func onBranchButton1ButtonUp() -> void:
	if currentBranch["exitDialogue1"]:
		exitDialogue()
		return
	currentBranch = button1Branch
	sayCurrentBranch()


func onNoBranchButtonUp() -> void:
	if currentBranch["exitDialogue"]:
		exitDialogue()
		return
	currentBranch = loadedDialogue.get(currentBranch["nextDialogue"])
	sayCurrentBranch()


func loadDialogue() -> Dictionary:
	var file = File.new()
	file.open(dialoguePath, File.READ)
	var dialogue: Dictionary = parse_json(file.get_as_text())
	return dialogue


func sayCurrentBranch() -> void:
	emit_signal("say_dialogue", currentBranch["text"])

	if currentBranch.has("branchID0"):
		changeNoBranchButtonState(false)
		changeBranchButtonsState(true)
		updateBranchButtons()
		if loadedDialogue.has(currentBranch["branchID0"]):
			button0Branch = loadedDialogue.get(currentBranch["branchID0"])
		if loadedDialogue.has(currentBranch["branchID1"]):
			button1Branch = loadedDialogue.get(currentBranch["branchID1"])
	else:
		changeBranchButtonsState(false)
		changeNoBranchButtonState(true)
		$NoBranchButton.text = currentBranch["choice"]
	

func updateBranchButtons() -> void:
	if currentBranch.has("branchChoice0"):
		$BranchButton0.text = currentBranch["branchChoice0"]
	if currentBranch.has("branchChoice1"):
		$BranchButton1.text = currentBranch["branchChoice1"]


func exitDialogue() -> void:
	changeBranchButtonsState(false)
	changeNoBranchButtonState(false)
	emit_signal("say_dialogue", "you exited the dialogue T_T")


func changeBranchButtonsState(enabled: bool) -> void:
	$BranchButton0.visible = enabled
	$BranchButton1.visible = enabled
	$BranchButton0.disabled = not enabled
	$BranchButton1.disabled = not enabled


func changeNoBranchButtonState(enabled: bool) -> void:
	$NoBranchButton.disabled = not enabled
	$NoBranchButton.visible = enabled
