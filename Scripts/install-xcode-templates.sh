PROJECT="Trimarr"

# Create folder
mkdir -p ~/Library/Developer/Xcode/Templates/File\ Templates/Custom\ Templates

# remove previous alias
rm -df ~/Library/Developer/Xcode/Templates/File\ Templates/Custom\ Templates/$PROJECT

# Install Templates
ln -Fsw $PWD/../xctemplates ~/Library/Developer/Xcode/Templates/File\ Templates/Custom\ Templates/$PROJECT