# Peer Assessment: Kailani Latimer

## Automate
### The entire analysis is automated
The data reading and cleaning appears to be happening in one standalone script: 1_clean_data.R. This creates the csv file which is in the output folder. The analysis isn't performed anywhere else except for the quarto paper file. There's only one file that has a function in the R folder, which is ideal. And as far as I can tell, all the scripts run without errors. So, I think you meet this spec!

### The analysis produces the expected output
The quarto document calculates the moving averages and creates a reasonable approximation of the original figure! So, I think you meet this spec as well. 

Some reccomendations I have are: Use echo = FALSE and include = FALSE to hide the library() and source() output code. And, alter the code so the figure's caption is at the bottom, and add a concise, descriptive title to the figure so readers know what they're looking at. 

## Organize
### Data are properly organized
Both raw data and output data are in their own respective folder. Great work, you meet this spec!

### Code is properly organized
There's at least one function in the R file and all code appears to be necessary for the analysis (besides the scratch file). So, you pass this spec too!

## Document
### The repo has an effective README
Good, descriptive title. I like how you included the links right off the bat. There could be a little more information on the repository's purpose. If someone stumbled across it, I imagine they would be a little confused about what was happening. There's no detail about accessing the data within the repository and how to use it. This is helpful for users to know exactly how and where to use certain code either for their own project or to recreate your project. The authors and references section looks good!

### Code follows a professional style
All the code follows a clear, organized style. Your comments in clean_data and moving-average are succinct, clear, organized, and appear to be in the appropriate spots. I would say you passed this spec!

Overall good work! A little work on the README and you'll be golden. 