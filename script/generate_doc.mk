#
#
#

all: dummy
	(cd $(PROJECT_DIR) ; \
	 mkdir -p $(DOCUMENT_DIR) ; \
	 jazzy -o $(DOCUMENT_DIR) \
	   --author "Steel Wheels Project" \
	   --author_url "https://sites.google.com/site/steelwheelsproject/" \
	   --readme $(README_FILE) \
	   --module $(MODULE_NAME) \
	   --github_url https://github.com/steelwheels/$(GITHUB_NAME) \
	)

dummy:

