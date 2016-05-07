#
#
#

all: document_dir
	(cd $(PROJECT_DIR) ; \
	 jazzy -o $(DOCUMENT_DIR) \
	   --author "Steel Wheels Project" \
	   --author_url "https://sites.google.com/site/steelwheelsproject/" \
	   --readme $(README_FILE) \
	   --module $(MODULE_NAME) \
	   --github_url https://github.com/steelwheels/$(GITHUB_NAME) \
	)

document_dir: dummy
	if [ ! -d ../Document ] ; then \
		mkdir ../Document ; \
	fi

dummy:

