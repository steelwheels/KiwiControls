#
#
#

all: dummy
	(cd $(PROJECT_DIR) ; \
	 mkdir -p $(DOCUMENT_DIR) ; \
	 jazzy -o $(DOCUMENT_DIR) \
	   --author "Steel Wheels Project" \
	   --author_url "http://steelwheels.github.io/" \
	   --readme $(README_FILE) \
	   --module $(MODULE_NAME) \
	   --github_url https://github.com/steelwheels/$(GITHUB_NAME) \
	)

dummy:

