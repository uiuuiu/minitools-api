class ShortedLink < Shortener::ShortenedUrl
  # generate a shortened link from a url
  # link to a user if one specified
  # throw an exception if anything goes wrong

  # validates :url, presence: true, format: URI::regexp(%w[http https])
  # validates_format_of :url, with: URI.regexp
  URL_REGEX = /(http|https):\/\/[a-zA-Z0-9\-\#\/\_]+[\.][a-zA-Z0-9\-\.\#\/\_]+/i

  def self.generate!(destination_url, owner: nil, custom_key: nil, expires_at: nil, fresh: false, category: nil, title: nil, description: nil)
    # if we get a shortened_url object with a different owner, generate
    # new one for the new owner. Otherwise return same object
    # errors.
    unless destination_url.to_s.match(URL_REGEX)
      record = self.new
      record.errors.add(:url, 'is not valid')
      return record
    end

    if destination_url.is_a? Shortener::ShortenedUrl
      if destination_url.owner == owner
        destination_url
      else
        generate!(
          destination_url.url,
          owner:      owner,
          custom_key: custom_key,
          expires_at: expires_at,
          fresh:      fresh,
          category:   category,
          title: title,
          description: description
        )
      end
    else
      scope = owner ? owner.shortened_urls : self
      creation_method = fresh ? 'create' : 'first_or_create'

      url_to_save = Shortener.auto_clean_url ? clean_url(destination_url) : destination_url

      scope.where(url: url_to_save, category: category).send(
        creation_method,
        custom_key: custom_key,
        expires_at: expires_at,
        title: title,
        description: description
      )
    end
  end

  # return shortened url on success, nil on failure
  def self.generate(destination_url, owner: nil, custom_key: nil, expires_at: nil, fresh: false, category: nil, title: nil, description: nil)
    begin
      generate!(
        destination_url,
        owner: owner,
        custom_key: custom_key,
        expires_at: expires_at,
        fresh: fresh,
        category: category,
        title: title,
        description: description
      )
    rescue => e
      logger.info e
      nil
    end
  end

  def self.fetch_with_token(token: nil, additional_params: {}, track: true)
    shortened_url = self.unexpired.where(unique_key: token).first

    url = if shortened_url
      shortened_url.increment_usage_count if track
      merge_params_to_url(url: shortened_url.url, params: additional_params)
    else
      Shortener.default_redirect || '/'
    end

    { url: url, shortened_url: shortened_url }
  end
end
