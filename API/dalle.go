package API

import (
	"encoding/json"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"strings"
)

const dalleURL = "https://api.openai-proxy.com/v1/images/generations"

type DalleRequest struct {
	Prompt string `json:"prompt"`
}

type DalleResponse struct {
	Created int64 `json:"created"`
	Data    []struct {
		RevisedPrompt string `json:"revised_prompt"`
		URL           string `json:"url"`
	} `json:"data"`
}

func DalleHandler(c *gin.Context) {
	var request DalleRequest

	// Bind the JSON request body to DalleRequest struct
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Error decoding JSON"})
		return
	}

	// Validate the prompt
	if request.Prompt == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Prompt cannot be empty"})
		return
	}

	n := 1
	size := "1024x1024"

	data := map[string]interface{}{
		"model":  "dall-e-2",
		"prompt": request.Prompt,
		"n":      n,
		"size":   size,
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error creating JSON"})
		return
	}

	req, err := http.NewRequest("POST", dalleURL, strings.NewReader(string(jsonData)))
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

	var jsonResponse DalleResponse
	if err := json.Unmarshal(body, &jsonResponse); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Error decoding OpenAI response JSON"})
		return
	}

	// Send the generated images back to the frontend
	if len(jsonResponse.Data) > 0 {
		c.JSON(http.StatusOK, jsonResponse.Data[0].URL)
	} else {
		c.JSON(http.StatusNoContent, "no image generated")
	}
}
