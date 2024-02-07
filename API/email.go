package API

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"strings"
)

const chatURL = "https://api.openai-proxy.com/v1/chat/completions"

type EmailRequest struct {
	UserInput string `json:"user_input"`
	Sender    string `json:"sender"`
	Recipient string `json:"recipient"`
	Tone      string `json:"tone"`
}

type EmailResponse struct {
	ID      string `json:"id"`
	Object  string `json:"object"`
	Created int64  `json:"created"`
	Model   string `json:"model"`
	Choices []struct {
		Index        int         `json:"index"`
		Message      Message     `json:"message"`
		Logprobs     interface{} `json:"logprobs"`
		FinishReason string      `json:"finish_reason"`
	} `json:"choices"`
	Usage struct {
		PromptTokens     int `json:"prompt_tokens"`
		CompletionTokens int `json:"completion_tokens"`
		TotalTokens      int `json:"total_tokens"`
	} `json:"usage"`
	SystemFingerprint interface{} `json:"system_fingerprint"`
}

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

func EmailHandler(c *gin.Context) {
	var request EmailRequest

	// Bind the JSON request body to EmailRequest struct
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error decoding JSON"})
		return
	}

	// Validate the user input
	if request.UserInput == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "User input cannot be empty"})
		return
	}

	prompt := []map[string]interface{}{
		{
			"role":    "system",
			"content": "You are a helpful assistant who is required to help me with writing an email. You need to adjust the content and tone of the email according to my requests",
		},
		{
			"role":    "user",
			"content": "The sender of this email is " + request.Sender + " and the recipient of this email is " + request.Recipient + ". The tone of this email should be " + request.Tone + ". Here's the specific requirements: " + request.UserInput,
		},
	}

	temperature := 0.7
	maxTokens := 1000

	data := map[string]interface{}{
		"model":       "gpt-3.5-turbo",
		"messages":    prompt,
		"temperature": temperature,
		"max_tokens":  maxTokens,
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating JSON"})
		return
	}

	req, err := http.NewRequest("POST", chatURL, strings.NewReader(string(jsonData)))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating HTTP request"})
		return
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer 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")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error making HTTP request to OpenAI"})
		return
	}

	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error reading response body from OpenAI"})
		return
	}

	var jsonResponse EmailResponse
	if err := json.Unmarshal(body, &jsonResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error decoding OpenAI response JSON"})
		return
	}

	// Send the generated email back to the frontend
	if len(jsonResponse.Choices) > 0 {
		c.JSON(http.StatusOK, jsonResponse.Choices[0].Message.Content)
	} else {
		c.JSON(http.StatusNoContent, "no email generated")
	}
}
