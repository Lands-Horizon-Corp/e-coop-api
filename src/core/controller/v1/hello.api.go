package v1

import "context"

type HelloWorldResponse struct {
	Message string `json:"message"`
}

//encore:api public method=GET path=/hello
func HelloWorld(ctx context.Context) (*HelloWorldResponse, error) {
	return &HelloWorldResponse{Message: "Hello, World!"}, nil
}
