using Godot;
using System;

public class Hero : Node2D
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";
	public int health = 10;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print("Hello");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{
		
//		position.x += axisX;
	}
	
	public override void _Input(InputEvent inputEvent)
	{
		var axisX = inputEvent.get_action_strength("move_right") - inputEvent.get_action_strength("move_left");
		position.x += position.x + axisX * delta;
		// Position.Set(Position.x + axisX * delta);
	}
}
