#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No color

# Initialize pass flags
config_sound=true
all_files_present=true

# Function to print success messages
success() {
	echo -e "${GREEN}$1${NC}"
}

# Function to print failure messages
fail() {
	echo -e "${RED}$1${NC}"
}

# Function to print warning messages
warning() {
	echo -e "${YELLOW}$1${NC}"
}

# Check for the presence of config.toml
if [ -f "config.toml" ]; then
	success "Found config.toml"

	# Check for at least 10 "=" symbols in config.toml
	equal_count=$(grep -o "=" config.toml | wc -l)
	if [ "$equal_count" -ge 10 ]; then
		success "config.toml has at least 10 custom configs."
	else
		warning "config.toml does NOT have 10 custom configs or more."
		config_sound=false
	fi

	# Check for at least 4 "," symbols in config.toml
	comma_count=$(grep -o "," config.toml | wc -l)
	if [ "$comma_count" -ge 4 ]; then
		success "config.toml has a custom config that is a sequence of 5 commands or more."
	else
		warning "config.toml does NOT have a custom config that is a sequence of 5 commands or more."
		config_sound=false
	fi
else
	fail "config.toml is NOT found"
	all_files_present=false
fi

# Check for the presence of trick.cast
if [ -f "trick.cast" ]; then
	success "Found trick.cast"
else
	fail "trick.cast is NOT found"
	all_files_present=false
fi

# Check for the presence of languages.toml
if [ -f "languages.toml" ]; then
	success "Found languages.toml"
else
	fail "languages.toml is NOT found"
	all_files_present=false
fi

# Check for the presence of code.cast
if [ -f "code.cast" ]; then
	success "Found code.cast"
else
	fail "code.cast is NOT found"
	all_files_present=false
fi

# Final summary
echo ""
if $all_files_present; then
	if $config_sound; then
		echo -e "${GREEN}All checks passed. You can upload your submission to GitHub.${NC}"
	else
		echo -e "${YELLOW}All required files are present, but some config.toml conditions are not met. GitHub CI will accept this submission, but your solution likely is incorrect.${NC}"
	fi
else
	echo -e "${RED}GitHub CI will NOT accept this submission. Files are missing.${NC}"
	if ! $config_sound; then
		echo -e "${RED}In addition, the config.toml file is unsound.${NC}"
	fi
fi
