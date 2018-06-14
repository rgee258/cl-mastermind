class Codebreaker

	def initialize
		@correct_code = [" "," "," "," "]
		@current_code = []
		@available_colors = ["red", "orange", "yellow", "green", "blue", "purple"]
		@white_colors = []
	end

	def input_pattern_player
		invalid_input = true
		pattern = []
		while (invalid_input)
			start_again = false
			puts "Input what you think is the order of the correct colored pegs using spaces:"
			input = gets.chomp.downcase

			# Try again if there's an empty input
			if (input.empty?)
				puts "You need to enter some kind of guess! Let's try again..."
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
			# Prepare to exit loop and push all values of input into pattern to be returned
			invalid_input = false
			input.each do |peg|
				pattern.push(peg)
			end
		end
		pattern
	end

	def input_pattern_computer(feedback)

		# Handle the feedback and update the progress we have so far
		# Cycle through each index of the feedback array
		4.times do |i|
			# Save black peg feedback to the correct code in the same spot
			if (feedback[i] == "black")
				if (@correct_code[i] == " ")
					@correct_code[i] = @current_code[i]
					@available_colors.delete(@current_code[i])
					@white_colors.delete(@current_code[i])
				end
			# Remove colors that are marked as none
			elsif (feedback[i] == "none")
				@available_colors.delete(@current_code[i])
			# Keep whites within the new answer and check for dupes
			elsif (feedback[i] == "white")
				add_white = true
				@white_colors.each do |white_peg|
					if (@current_code[i] == white_peg)
						add_white = false
					end
				end

				if (add_white)
					@white_colors.push(@current_code[i])
					@available_colors.delete(@current_code[i])
				end
			else
				puts "ERROR handling feedback by computer."
			end
		end

		# Create the new input
		next_input = [" ", " ", " ", " "]
		# Create temporary arrays that we can reduce in count when we insert them for the new input
		temp_white = @white_colors
		temp_avail = @available_colors
		# Check for duplicate values to make sure we don't reuse any
		dupe_white = []
		dupe_avail = []


		# Insert into our new guess individually
		4.times do |i|
			# If we have a correct spot, just put back what we saved
			if (@correct_code[i] != " ")
				next_input[i] = @correct_code[i]
			# Check to make sure we use all of the white pegs first
			elsif (temp_white.length > 0)
				inserting_white = true
				while (inserting_white)
					dupe_found = false
					rand_num = rand(temp_white.length)
					dupe_white.each do |white|
						if (white == temp_white[rand_num])
							dupe_found = true
						end
					end
					if (dupe_found)
						next
					end
					next_input[i] = temp_white.delete(temp_white[rand_num])
					inserting_white = false
				end
			# Then check for the colors we've never touched yet
			# This is never reached if we have all whites and blacks
			elsif (temp_avail.length > 0)
				inserting_unused = true
				while (inserting_unused)
					dupe_found = false
					rand_num = rand(temp_avail.length)
					dupe_avail.each do |unused|
						if (unused == temp_avail[rand_num])
							dupe_found = true
						end
					end
					if (dupe_found)
						next
					end
					next_input[i] = temp_avail.delete(temp_avail[rand_num])
					inserting_unused = false
				end
			else
				puts "ERROR creating new input by computer for entry #{i}."
			end
		end

		@current_code = next_input
		@current_code
	end

	def input_first_pattern_computer
		used_colors = []
		while (@current_code.length < 4)
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
					@current_code.push("red")
				when 2
					used_colors.push(2)
					@current_code.push("orange")
				when 3
					used_colors.push(3)
					@current_code.push("yellow")
				when 4
					used_colors.push(4)
					@current_code.push("green")
				when 5
					used_colors.push(5)
					@current_code.push("blue")
				when 6
					used_colors.push(6)
					@current_code.push("purple")
				else
					puts "ERROR creating code."
					exit(1)
				end
			end
			duped_color = false
		end
		@current_code
	end

end