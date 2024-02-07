package config

import "github.com/spf13/viper"

func LoadConfig() {
	// Load configuration from environment variables, config files, or other sources
	viper.Set("database.url", "mysql://root:Ykz_20041107@tcp(localhost:3306)/myDB?charset=utf8&parseTime=True&loc=Local")
}
