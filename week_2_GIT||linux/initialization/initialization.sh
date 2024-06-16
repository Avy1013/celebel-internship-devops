


cd ~/my_project
git init

# Step 2: Create a new file
echo "# My Project" > README.md

# Step 3: Stage and commit changes
git add README.md
git commit -m "first commit"

# Step 4: created a remote repo names celebel_internship

# Step 5: Add remote repo
git remote add origin https://github.com/Avy1013/celebel-internship-devops.git

# Step 6: Push changes 
git push -u origin master
