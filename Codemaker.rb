class Codemaker

	attr_reader :code

	def initialize
		@code = []
	end

	def choose_code_computer
		used_colors = []
		while (code.length < 4)
			color_num = 1 + rand(6)
			duped_color = false
			used_colors.each do |elem|
				if (elem == color_num)
					duped_color = true
				end
			end
			if (duped_color == false)
				case color_num
				when 1
					used_colors.push(1)
					@code.push("red")
				when 2
					used_colors.push(2)
					@code.push("orange")
				when 3
					used_colors.push(3)
					@code.push("yellow")
				when 4
					used_colors.push(4)
					@code.push("green")
				when 5
					used_colors.push(5)
					@code.push("blue")
				when 6
					used_colors.push(6)
					@code.push("purple")
				else
					puts "ERROR creating code."
					exit(1)
				end
			end
			duped_color = false
		end
	end

	def choose_code_player
		invalid_input = true
		pattern = []
		while (invalid_input)
			start_again = false
			puts "Input the secret code that you want using spaces:"
			input = gets.chomp.downcase

			# Try again if there's an empty input
			if (input.empty?)
				puts "You need to enter a secret code! Let's try again..."
				next
			end

			# Split code and check to make sure the length is correct
			input = input.split(" ")
			if (input.length != 4)
				puts "\nYou need a guess with four colors. Let's try again..."
				next
			end

			# Check first to make sure all strings are valid
			input.each do |peg|
				case peg
				when "red", "orange", "yellow", "blue", "green", "purple"
				else
					puts "\nLooks like one of your inputs are invalid. Let's try again..."
					start_again = true
					break
				end
			end
			if (start_again)
				next
			end
			# Check to make sure no inputs are duped
			input.each do |peg|
				dupe_count = 0
				input.each do |check|
					if (peg == check)
						dupe_count += 1
					end
				end
				if (dupe_count > 1)
					puts "\nLooks like you repeated one of your inputs. Let's try again..."
					start_again = true
					break
				end
			end
			if (start_again)
				next
			end
			# Prepare to exit loop and push all values of input into code to be used for the game
			invalid_input = false
			input.each do |peg|
				@code.push(peg)
			end
		end
	end

	def get_feedback(guess)
		feedback = ["none", "none", "none", "none"]
		index = 0
		# Start by taking each element from the guess array
		guess.each do |outer|
			# If the guess element is present in the code, mark as white because the color is correct
			@code.each do |inner|
				if (outer == inner)
					feedback[index] = "white"
					break
				end
			end
			# If we marked it as white, then compare the current guess element to the matching element in the code, if corect mark as black
			if (feedback[index] == "white")
				if (guess[index] == @code[index])
					feedback[index] = "black"
				end
			end
			# Keep track of the index of the guess element
			index += 1
		end
		feedback
	end

end