# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Constants::Shared::HMAC_SECRET
JWTSessions.refresh_exp_time = Constants::Jwt::REFRESH_TOKEN_EXP_TIME