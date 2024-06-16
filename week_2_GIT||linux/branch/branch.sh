
git checkout main

# Create and switch to a new branch

git checkout -b new
cd "week_2_GIT||linux"
cd branch

# Make changes (example: modify README.md)
echo "New feature added!" >> text.txt

# Stage changes
git add text.txt

# Commit changes
git commit -m "Added new feature message to README"

# Push changes to the new branch on the remote repository
git push -u origin new

# Create a pull request on GitHub (assuming GitHub)

# Go to compare and pull request 
# and then create a pull request 
# then add a title and description
# see if there is any merge conflict
# if not any merge conflict 
# click on merge pull
