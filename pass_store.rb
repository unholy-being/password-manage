require 'json'
require 'openssl'
require 'base64'

class PasswordStore
  def initialize
    @file = "credentials.enc"
    @key = Digest::SHA256.digest("lofi-secret")
    @iv = @key[0..15]
    load_data
  end

  def add(site, username, password)
    @data[site] = { "username" => username, "password" => password }
    save_data
  end

  def list
    if @data.empty?
      puts "No credentials saved."
    else
      @data.each do |site, info|
        puts "#{site}: #{info["username"]} / #{info["password"]}"
      end
    end
  end

  def delete(site)
    if @data.delete(site)
      save_data
      puts "Deleted #{site}."
    else
      puts "No such entry."
    end
  end

  private

  def load_data
    if File.exist?(@file)
      encrypted = File.read(@file)
      json = decrypt(encrypted)
      @data = JSON.parse(json)
    else
      @data = {}
    end
  end

  def save_data
    json = @data.to_json
    encrypted = encrypt(json)
    File.write(@file, encrypted)
  end

  def encrypt(text)
    cipher = OpenSSL::Cipher.new("AES-128-CBC")
    cipher.encrypt
    cipher.key = @key
    cipher.iv = @iv
    encrypted = cipher.update(text) + cipher.final
    Base64.encode64(encrypted)
  end

  def decrypt(text)
    decipher = OpenSSL::Cipher.new("AES-128-CBC")
    decipher.decrypt
    decipher.key = @key
    decipher.iv = @iv
    decoded = Base64.decode64(text)
    decipher.update(decoded) + decipher.final
  end
end
