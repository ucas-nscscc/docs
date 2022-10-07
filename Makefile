.PHONY: push slides
push:
	git push origin nscscc-2023

slides:
	reveal-md slides/ --static docs --static-dirs=img
