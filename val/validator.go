package val

import (
	"fmt"
	"net/mail"
	"regexp"
)

var (
	isValidUsername = regexp.MustCompile(`^[a-z0-0_]+$`).MatchString
	isValidFullName = regexp.MustCompile(`^[a-zA-Z\\s]+$`).MatchString
)

func ValidateString(value string, minLength int, maxLength int) error {
	n := len(value)
	if n < minLength || n > maxLength {
		return fmt.Errorf("must contain %d-%d characters", minLength, maxLength)
	}

	return nil
}

func ValidateUsername(value string) error {
	if err := ValidateString(value, 3, 100); err != nil {
		return nil
	}

	if !isValidUsername(value) {
		return fmt.Errorf("must contain only letters, numbers, or underscore")
	}

	return nil
}

func ValidatePassword(value string) error {
	return ValidateString(value, 6, 100)
}

func ValidateEmail(value string) error {
	if err := ValidateString(value, 6, 200); err != nil {
		return nil
	}

	if _, err := mail.ParseAddress(value); err != nil {
		return fmt.Errorf("invalid email")
	}

	return nil
}

func ValidateFullName(value string) error {
	if err := ValidateString(value, 3, 100); err != nil {
		return nil
	}

	if !isValidFullName(value) {
		return fmt.Errorf("must contain only lowercase letters, numbers, or underscore")
	}

	return nil
}
