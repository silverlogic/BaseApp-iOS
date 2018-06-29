## Makefile
# Commands for abstracting setup and local deployment

# Macros
DEPLOY_STORE_PASSWORD = 1
GEM := $(shell command -v gem 2> /dev/null)

# Functions
define invoke_lane
	FASTLANE_PASSWORD=$(PASSWORD) FASTLANE_DONT_STORE_PASSWORD=$(DEPLOY_STORE_PASSWORD) fastlane $(1)
endef

define reset_xcoodeproj
	@echo "Resetting project.pbxproj to default configuration"
	@git checkout BaseApp.xcodeproj/project.pbxproj
endef

define list_itc_teams
	./Scripts/list_itc_teams.rb $(USERNAME) $(PASSWORD)
endef

# Target Rules
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help

install_fastlane:
ifndef GEM
	$(error "RubyGems does not exist on this system. RubyGems is required in order to continue")
endif
	@echo "Installing Fastlane toolchain"
	@gem install fastlane

check_password:
ifndef PASSWORD
	$(error "Password for Fastlane not set. Password is required to continue")
endif

check_username:
ifndef USERNAME
	$(error "Username for Fastlane not set. Username is required to continue")
endif

new_appstore_profile:
	@echo "Creating new provision profile and certificate for app store"
	$(call invoke_lane, generate_appstore_profile)

new_fabric_profile:
	@echo "Creating new provision profile and certificate for Fabric"
	$(call invoke_lane, generate_fabric_profile)

release_production:
	@echo "Deploying to the app store"
	$(call invoke_lane, itunes_connect)

release_staging:
	@echo "Deploying to Fabric"
	$(call invoke_lane, fabric)

list_all_itc_teams:
	@echo "Listing available iTunes Connect Teams"
	$(call list_itc_teams)

clean: 
	@rm -rf ~/Library/Caches/CocoaPods
	@rm -rf Podfile.lock
	@rm -rf Pods/
	@rm -rf ~/Library/Developer/Xcode/DerivedData/*
	@pod deintegrate
	@pod setup

init: ## Configures this repo's githooks with the local repository ones.
	git config core.hooksPath .githooks

open_xcode: ## Installs the required dependencies and opens the project in Xcode
	@pod install
	@open BaseApp.xcworkspace

update_devices: check_password install_fastlane ## Updates the Ad hoc distribution profile with new test devices
	@echo "Updating test devices"
	$(call invoke_lane, update_test_devices)


# Target Dependencies
generate_appstore_profile: check_password install_fastlane new_appstore_profile ## Generates a new provisioning profile for app store submission

generate_fabric_profile: check_password install_fastlane new_fabric_profile ## Generates a new provisioning profile for Fabric submission

deploy_production: check_password install_fastlane release_production ## Deploys the application to the app store
	$(call reset_xcoodeproj)

deploy_clean_production: check_password install_fastlane new_appstore_profile release_production ## Deploys the application to the app store with a new provisioning profile
	$(call reset_xcoodeproj)

deploy_staging: check_password install_fastlane release_staging ## Deploys the application to Fabric
	$(call reset_xcoodeproj)

deploy_clean_staging: check_password install_fastlane new_fabric_profile release_staging ## Deploys the application to Fabric with a new provisioning profile
	$(call reset_xcoodeproj)

open_clean_xcode: clean open_xcode ## Cleans the project, installs the required dependencies and opens the project in Xcode

list_available_itc_teams: check_username check_password install_fastlane list_all_itc_teams ### Lists the available iTunes Connect teams that our developer account has access to
