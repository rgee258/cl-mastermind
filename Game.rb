class Game

require "./Codebreaker"
require "./Codemaker"

	def initialize
		# Change back to 12
		@MAX_TURNS = 12
		@player_role = "none"
	end

	def instructions
		puts "\n--------------------------------------------------------------------------------------------------------"
		puts "Let's play a game of Mastermind!"
		puts "This game uses a colored set of pegs, which we'll refer to by color."
		puts "The codemaker will pick a set of 4 colored pegs that the codebreaker will need to guess."
		puts "The codebreaker will try to guess the set of 4 colored pegs."
		puts "There are 6 colors that the code is made from: Red, Orange, Yellow, Green, Blue, and Purple."
		puts "After each turn by the codebreaker, they'll receive feedback using black, white, and no pegs."
		puts "Black Pegs: The colored peg picked is one of the correct colors and the position is correct."
		puts "White Pegs: The colored peg picked is one of the correct colors, but the position is wrong."
		puts "No Peg: The colored peg is not one of the correct colors at all."
		puts "So each turn this goes back and forth until either the codebreaker or codemaker wins."
		puts "There are twelve turns for guessing, so give it your best!"
		puts "--------------------------------------------------------------------------------------------------------\n\n"
	end

	def choose_role

		choosing_role = true

		while (choosing_role)
			puts "So what role would you like to play in this game of Mastermind?"
			puts "Choose between the codemaker or the codebreaker."
			role = gets.chomp.downcase
			if (role.empty?)
				puts "You need to pick a role! Let's try again..."
			elsif (role == "codemaker" || role == "codebreaker")
				@player_role = role
				choosing_role = false
			else
				puts "That's not a proper role, let's try again..."
			end
		end
	end

	def game_won?(guess, answer)
		4.times do |i|
			if (guess[i] != answer[i])
				return false
			end
		end
		true
	end

	def announce_results(turns_used, answer)
		if (@player_role == "codebreaker")
			if (turns_used <= @MAX_TURNS)
				puts "Congratulations codebreaker, you win!"
				puts "Good job guessing the code!"
			else
				puts "Looks like you didn't guess the code in time..."
				puts "The code you were trying to guess was: \n\n"
				answer.each do |peg|
					print "#{peg} "
				end
				puts "\n\n"
				puts "You gave it your best trying to guess though, if you want to try again let's go!"
			end
		elsif (@player_role == "codemaker")
			if (turns_used <= @MAX_TURNS)
				puts "Looks like the computer figured out your code."
				puts "Want to try again and see if it can figure it out next time?"
			else
				puts "Good job codemaker, the computer wasn't able to guess your code."
				puts "Looks like you win this one!"
			end
		end
	end

	def play_game
		turn_count = 1

		instructions
		choose_role

		cb = Codebreaker.new()
		cm = Codemaker.new()

		if (@player_role == "codebreaker")
			puts "So you've chosen to be the codebreaker? Alright, let's begin then."
			cm.choose_code_computer
			puts "The computer's chosen a code for you, time to break it!\n\n"
		elsif (@player_role == "codemaker")
			puts "Being crafty as a codemaker? Alright, let's begin then."
			cm.choose_code_player
			puts "We're all set! Let's see if the computer can crack your code!\n"
		else
			puts "ERROR checking for role."
		end

		# Keep these out of the loop since we need to reuse the previous results from the last turn
		turn_input = nil
		turn_feedback = nil

		while (turn_count <= @MAX_TURNS)

			if (@player_role == "codebreaker")
				puts "Time to make your guess for turn #{turn_count}."
				turn_input = cb.input_pattern_player
				puts "\nYour guess: "
				turn_input.each do |peg|
					print "#{peg} "
				end
				turn_feedback = cm.get_feedback(turn_input)
				puts "\nYour feedback: "
				turn_feedback.each do |peg|
					print "#{peg} "
				end
				puts "\n\n"

				if (game_won?(turn_input, cm.code))
					break
				end
			elsif (@player_role == "codemaker")
				# We need to handle the computer's first turn differently since we're just picking random values
				if (turn_count == 1)
					turn_input = cb.input_first_pattern_computer
					puts "\nComputer's guess: "
					turn_input.each do |peg|
						print "#{peg} "
					end
					turn_feedback = cm.get_feedback(turn_input)
					puts "\nComputer's feedback: "
					turn_feedback.each do |peg|
						print "#{peg} "
					end
					puts "\n\n"
				# Every other turn will reuse the previous turn's feedback to create logic for the correct code
				else
					turn_input = cb.input_pattern_computer(turn_feedback)
					puts "\nComputer's guess: "
					turn_input.each do |peg|
						print "#{peg} "
					end
					turn_feedback = cm.get_feedback(turn_input)
					puts "\nComputer's feedback: "
					turn_feedback.each do |peg|
						print "#{peg} "
					end
					puts "\n\n"
				end

				if (game_won?(turn_input, cm.code))
					break
				end
			end

			turn_count += 1
		end

		announce_results(turn_count, cm.code)

	end

end

game = Game.new
game.play_game