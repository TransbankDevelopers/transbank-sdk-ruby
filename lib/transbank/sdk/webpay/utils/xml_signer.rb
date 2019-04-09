require 'signer'

module Transbank
  module Webpay
    class XmlSigner
      XML_HEADER = "<env:Header><wsse:Security xmlns:wsse='http://docs.oasis-" \
                   'open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1' \
                   ".0.xsd' wsse:mustUnderstand='1'/></env:Header>".freeze
      SOAPENV = 'http://schemas.xmlsoap.org/soap/envelope/'.freeze

      def self.perform(unsigned_xml_string, configuration)
        unsigned_document = Nokogiri::XML(unsigned_xml_string)
        unsigned_document.at_xpath('//env:Envelope').prepend_child(XML_HEADER)

        signer = instantiate_signer(unsigned_document.to_s, configuration)

        digest_nodes(signer)

        signer.sign!(issuer_serial: true, issuer_in_security_token: true)
        signer.to_xml.to_s
      end

      def self.instantiate_signer(document, configuration)
        signer = Signer.new(document)
        signer.cert = OpenSSL::X509::Certificate.new(configuration.public_cert)
        signer.private_key = OpenSSL::PKey::RSA.new(configuration.private_key)
        signer
      end

      def self.digest_nodes(signer)
        signer.document.xpath('//soapenv:Body', soapenv: SOAPENV).each do |node|
          signer.digest!(node)
        end
      end

      private_class_method :instantiate_signer, :digest_nodes
    end
  end
end
