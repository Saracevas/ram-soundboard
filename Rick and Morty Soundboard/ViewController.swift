//
//  ViewController.swift
//  Rick and Morty Soundboard
//
//  Created by Sylvester Saracevas on 05/01/2017.
//  Copyright © 2017 Sylvester Saracevas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	struct Sound {
		let soundName: String
		let fileName: String
		let fileExtension: String
	}
	
	struct Character {
		let avatar: UIImage
		let name: String
	}
	
	var currentlySelectedRowIndexPath: IndexPath? = nil
	
	@IBOutlet weak var tableView: UITableView!
	var audioPlayer: AVAudioPlayer?
	let themeColor = UIColor(red: 0/255, green: 175/255, blue: 200/255, alpha: 1.0)
	
	let characters = [
		Character(avatar: #imageLiteral(resourceName: "Rick"), name: "Rick"),
		Character(avatar: #imageLiteral(resourceName: "Morty"), name: "Morty"),
		Character(avatar: #imageLiteral(resourceName: "Poopybutthole"), name: "Mr Poopybutthole"),
		Character(avatar: #imageLiteral(resourceName: "Cromulons"), name: "Cromulons"),
		Character(avatar: #imageLiteral(resourceName: "Jerry"), name: "Jerry"),
	]
	
	let sounds = [
		// Rick
		[
			Sound(soundName: "AIDS!", fileName: "rick_aids", fileExtension: "wav"),
		],
		// Morty
		[
			Sound(soundName: "Oh man!", fileName: "morty_oh_man", fileExtension: "wav"),
			Sound(soundName: "Gazorpazorpfield", fileName: "morty_gazorpazorpfield", fileExtension: "wav")
		],
		// Mr. Poopybutthole
        [
            Sound(soundName: "Ooh Wee!", fileName: "mr_poopybutthole_ooh_wee", fileExtension: "wav")
        ],
		// Cromulons
		[
			Sound(soundName: "Hmm...", fileName: "cromulons_hmm", fileExtension: "wav"),
			Sound(soundName: "I like what you got!", fileName: "cromulons_i_like_what_you_got", fileExtension: "wav"),
			Sound(soundName: "Good job!", fileName: "cromulons_good_job", fileExtension: "wav"),
			Sound(soundName: "Boo, not cool!", fileName: "cromulons_boo_not_cool", fileExtension: "wav")
        ],
        // Jerry
        [
            Sound(soundName: "Life is an effort!", fileName: "jerry_life_is_an_effort", fileExtension: "wav")
        ]
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBar()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// Number of sections
	func numberOfSections(in tableView: UITableView) -> Int {
		return characters.count
	}
	
	// Number of rows in section
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sounds[section].count
	}
	
	// Display the titles in sections
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath)
		
		// Selection color
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.darkGray
		cell.selectedBackgroundView = backgroundView
		
		// Label for the name of the sound
		let sound = sounds[indexPath.section][indexPath.row]
		cell.backgroundColor = UIColor.clear
		cell.textLabel!.textColor = UIColor.white
		cell.textLabel!.text = sound.soundName
		
		return cell
	}
	
	// Play the sound
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// Set the global variable to the current row so that it can be deselected 
		// when the user uses the STOP button.
		currentlySelectedRowIndexPath = indexPath
		
		// Get the corresponding row sound.
		let sound = sounds[indexPath.section][indexPath.row]
		
		let url = URL(fileURLWithPath:
			Bundle.main.path(
				forResource: sound.fileName,
				ofType: sound.fileExtension)!
		)
		
		do {
			self.audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer!.prepareToPlay()
			audioPlayer!.volume = 1.0
			audioPlayer!.play()
		} catch let error as NSError {
			//self.player = nil
			print(error.localizedDescription)
		} catch {
			print("AVAudioPlayer init failed")
		}
		
		// Deselect row after the duration of the audio clip.
		DispatchQueue.main.asyncAfter(deadline: .now() + (audioPlayer?.duration)!) {
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
	}
	
	// Set the section names
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//			return headerTitles[section]
//	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		// Background Color
		view.tintColor = themeColor
		// Character for this section
		let character = characters[section]
		// Avatar
		let characterAvatar = UIImageView.init(image: character.avatar)
		characterAvatar.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
		view.addSubview(characterAvatar)
		// Character name
		let characterName = UILabel(frame: CGRect(x: 65, y: 17, width: 200, height: 25))
		characterName.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
		characterName.textColor = UIColor.white
		characterName.text = character.name
		view.addSubview(characterName)
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 60.0
	}
	
	func setupNavigationBar() {
		self.navigationController?.navigationBar.barStyle = UIBarStyle.black
		self.navigationController?.navigationBar.tintColor = UIColor.white
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "STOP", style: .plain, target: self, action: #selector(self.stopButtonPressed))
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "INFO", style: .plain, target: self, action: #selector(self.informationButtonPressed))
	}
	
	func stopButtonPressed() {
		audioPlayer?.stop()
		if let indexPath = currentlySelectedRowIndexPath {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	func informationButtonPressed() {
		performSegue(withIdentifier: "infoSegue", sender: self)
	}
	
}

