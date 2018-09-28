class Channel
  ## Contains static values for all possible channel values

  WEB = 'WEB'.freeze
  MOBILE = 'MOBILE'.freeze
  APP = 'APP'.freeze

  def self.values
    constants.map { |const| const_get const }
  end
end