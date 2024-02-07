package utils

import (
	"github.com/dgrijalva/jwt-go"
	"time"
)

var (
	jwtSecret = []byte("your-secret-key") // Replace with your actual secret key
)

// Claims represents the JWT claims structure.
type Claims struct {
	Username string `json:"username"`
	jwt.StandardClaims
}

// GenerateToken generates a JWT token for a user.
func GenerateToken(username string) (string, error) {
	claims := Claims{
		Username: username,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 24).Unix(), // Token expires in 24 hours
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(jwtSecret)
}

// VerifyToken verifies the JWT token and returns the claims.
func VerifyToken(tokenString string) (*Claims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*Claims); ok && token.Valid {
		return claims, nil
	}

	return nil, jwt.ErrSignatureInvalid
}
