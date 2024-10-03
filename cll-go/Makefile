# Makefile in cll-go

# Variables
GO_FILES = main.go
GO_BIN = cll-go

# Target to build the Go executable
all: $(GO_BIN)

$(GO_BIN): $(GO_FILES)
	go build -o $(GO_BIN) $(GO_FILES)

# Clean target
clean:
	rm -f $(GO_BIN)
