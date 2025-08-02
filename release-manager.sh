#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <new-version>"
  echo "Example: $0 1.0.1"
  exit 1
fi

NEW_VERSION=$1
CHANGELOG="CHANGELOG.md"

echo "Bumping version to $NEW_VERSION..."

# Example: replace version in configure.ac or version header
# Adjust paths as needed!
sed -i "s/^AC_INIT(\[.*\], \[.*\])/AC_INIT([$NEW_VERSION], [$NEW_VERSION])/" configure.ac

echo "Updating CHANGELOG.md..."

DATE=$(date +"%Y-%m-%d")
cat <<EOF >> $CHANGELOG

## [$NEW_VERSION] - $DATE
- Describe your changes here

EOF

echo "Committing changes..."
git add configure.ac $CHANGELOG
git commit -m "Bump version to $NEW_VERSION and update changelog"

echo "Creating Git tag..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo "Pushing commits and tags..."
git push
git push --tags

echo "Release $NEW_VERSION complete!"
