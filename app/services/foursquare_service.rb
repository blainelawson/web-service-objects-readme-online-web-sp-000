class FoursquareService
    def authenticate!(client_id, client_secret, code)
        resp = Faraday.get("https://foursquare.com/oauth2/access_token") do |req|
            req.params['client_id'] = client_id
            req.params['client_secret'] = client_secret
            req.params['grant_type'] = 'authorization_code'
            req.params['redirect_uri'] = "http://localhost:3000/auth"
            req.params['code'] = code
        end

        body = JSON.parse(resp.body)
        session[:token] = body["access_token"]
    end

    def friends(token)
        resp = Faraday.get("https://api.foursquare.com/v2/users/self/friends") do |req|
            req.params['oauth_token'] = session[:token]
            # don't forget that pesky v param for versioning
            req.params['v'] = '20160201'
        end
            
        JSON.parse(resp.body)["response"]["friends"]["items"]
    end

    def foursquare(client_id, client_secret, near)
        @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
            req.params['client_id'] = client_id
            req.params['client_secret'] = client_secret
            req.params['v'] = '20160201'
            req.params['near'] = near
            req.params['query'] = 'coffee shop'
        end
      
        JSON.parse(@resp.body)
    end
end