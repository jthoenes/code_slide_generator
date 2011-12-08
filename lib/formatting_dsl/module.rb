module FormattingDSL
  def self.formattings &block
    FormattingHandler.handle(&block)
  end
end