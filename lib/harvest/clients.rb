class Harvest
  class Clients < BaseApi
    def all
      response = Request.perform(:get, credentials, "/clients")
      Harvest::Client.parse(response.body)
    end
    
    def find(id)
      response = Request.perform(:get, credentials, "/clients/#{id}")
      Harvest::Client.parse(response.body)
    end
    
    def create(client)
      response = Request.perform(:post, credentials, "/clients", nil, client.to_xml)
      id = response.headers_hash["Location"].match(/\/clients\/(\d+)/)[1]
      find(client.id)
    end
    
    def update(client)
      Request.perform(:put, credentials, "/clients/#{client.id}", nil, client.to_xml)
      find(client.id)
    end
    
    def delete(client)
      Request.perform(:delete, credentials, "/clients/#{client.id}")
      client.id
    end
    
    def deactivate(client)
      if client.active?
        Request.perform(:post, credentials, "/clients/#{client.id}/toggle")
        client.active = false
      end
      client
    end
    
    def activate(client)
      if !client.active?
        Request.perform(:post, credentials, "/clients/#{client.id}/toggle")
        client.active = true
      end
      client
    end
  end
end