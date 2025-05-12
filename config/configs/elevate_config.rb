# frozen_string_literal: true

class ElevateConfig < ApplicationConfig
  # JWT token for the Elevate API, hardcoded as default since this is a case study. Never store secrets in code.
  attr_config jwt_token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiaWxsaW5nIiwiaWF0IjoxNzQzMDg1NDk5LCJleHAiOm51bGwsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6ImJpbGxpbmdfY2xpZW50In0.aRwnR_QP6AlOv_JanMkbhwe9ACDcJc5184pXdR0ksXg"
  attr_config api_host: "https://interviews-accounts.elevateapp.com"
  required :jwt_token, :api_host
end
