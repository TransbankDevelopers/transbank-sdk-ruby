module Transbank
  module Webpay
    class Configuration
      attr_accessor :private_key
      attr_accessor :public_cert
      attr_accessor :webpay_cert
      attr_accessor :commerce_code
      attr_accessor :environment

      DEFAULT_WEBPAY_CERTS = {
        TEST:
          "-----BEGIN CERTIFICATE-----\n" \
          "MIIEDzCCAvegAwIBAgIJAMaH4DFTKdnJMA0GCSqGSIb3DQEBCwUAMIGdMQswCQYD\n" \
          "VQQGEwJDTDERMA8GA1UECAwIU2FudGlhZ28xETAPBgNVBAcMCFNhbnRpYWdvMRcw\n" \
          "FQYDVQQKDA5UUkFOU0JBTksgUy5BLjESMBAGA1UECwwJU2VndXJpZGFkMQswCQYD\n" \
          "VQQDDAIyMDEuMCwGCSqGSIb3DQEJARYfc2VndXJpZGFkb3BlcmF0aXZhQHRyYW5z\n" \
          "YmFuay5jbDAeFw0xODA4MjQxOTU2MDlaFw0yMTA4MjMxOTU2MDlaMIGdMQswCQYD\n" \
          "VQQGEwJDTDERMA8GA1UECAwIU2FudGlhZ28xETAPBgNVBAcMCFNhbnRpYWdvMRcw\n" \
          "FQYDVQQKDA5UUkFOU0JBTksgUy5BLjESMBAGA1UECwwJU2VndXJpZGFkMQswCQYD\n" \
          "VQQDDAIyMDEuMCwGCSqGSIb3DQEJARYfc2VndXJpZGFkb3BlcmF0aXZhQHRyYW5z\n" \
          "YmFuay5jbDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJN+OJgQQqMb\n" \
          "iRZDb3x+JoTfSjyYsRc5k2CWvLpTPFxXuhDyp6mbdIpWIiNYEC4vufVZo5A3THar\n" \
          "cbnJRlW/4NVv5QM3gHN9WJ4QeIsrTLtvcIPlfUJNPLNeDqy84zum2YqAFmX5LWsp\n" \
          "SF1Ls6n7el8KNJAceaU+2ooN8QZdFZ3RnMc2vrHY7EU6wYGmf/VCEaDZCKqY6ElY\n" \
          "mt6/9b2lkhpQLdBn01IqqFpGrD+5DLmYrQur4/1BDVtdNLggX0K7kPk/mkPDq4ME\n" \
          "ytkc9/RI5HfJWoQ4EDQF6qcqPqxlMFDf5KEaoLVL230EdwOl0UyvlF25S9ubRyHy\n" \
          "mKWIEFSSXe0CAwEAAaNQME4wHQYDVR0OBBYEFP3nYSPX3YKF11RArC09hxjEMMBv\n" \
          "MB8GA1UdIwQYMBaAFP3nYSPX3YKF11RArC09hxjEMMBvMAwGA1UdEwQFMAMBAf8w\n" \
          "DQYJKoZIhvcNAQELBQADggEBAFHqOPGeg5IpeKz9LviiBGsJDReGVkQECXHp1QP4\n" \
          "8RpWDdXBKQqKUi7As97wmVksweaasnGlgL4YHShtJVPFbYG9COB+ElAaaiOoELsy\n" \
          "kjF3tyb0EgZ0Z3QIKabwxsxdBXmVyHjd13w6XGheca9QFane4GaqVhPVJJIH/zD2\n" \
          "mSc1boVSpaRc1f0oiMtiZf/rcY1/IyMXA9RVxtOtNs87Wjnwq6AiMjB15fLHfT7d\n" \
          "R48O6P0ZpWLlZwScyqDWcsg/4wNCL5Kaa5VgM03SKM6XoWTzkT7p0t0FPZVoGCyG\n" \
          "MX5lzVXafBH/sPd545fBH2J3xAY3jtP764G4M8JayOFzGB0=\n" \
          "-----END CERTIFICATE-----\n",
        LIVE:
          "-----BEGIN CERTIFICATE-----\n" \
          "MIIDizCCAnOgAwIBAgIJAIXzFTyfjyBkMA0GCSqGSIb3DQEBCwUAMFwxCzAJBgNV\n" \
          "BAYTAkNMMQswCQYDVQQIDAJSTTERMA8GA1UEBwwIU2FudGlhZ28xEjAQBgNVBAoM\n" \
          "CXRyYW5zYmFuazEMMAoGA1UECwwDUFJEMQswCQYDVQQDDAIxMDAeFw0xODAzMjkx\n" \
          "NjA4MjhaFw0yMzAzMjgxNjA4MjhaMFwxCzAJBgNVBAYTAkNMMQswCQYDVQQIDAJS\n" \
          "TTERMA8GA1UEBwwIU2FudGlhZ28xEjAQBgNVBAoMCXRyYW5zYmFuazEMMAoGA1UE\n" \
          "CwwDUFJEMQswCQYDVQQDDAIxMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC\n" \
          "ggEBAKRqDk/pv8GeWnEaTVhfw55fThmqbFZOHEc/Un7oVWP+ExjD0kZ/aAwMJZ3d\n" \
          "9hpbBExftjoyJ0AYKJXA2CyLGxRp30LapBa2lMehzdP6tC5nrCYbDFz8r8ZyN/ie\n" \
          "4lBQ8GjfONq34cLQfM+tOxyazgDYRnZVD9tvOcqI5bFwFKqpn/yMr9Eya7gTo/OP\n" \
          "wyz69sAF8MKr0YN941n6C1Cdrzp6cRftdj83nlI75Ue//rMYih/uQYiht4XWFjAA\n" \
          "usoOG/IVVCCHhVQGE/Rp22dAF8JzWYZWCe+ICOKjEzEZPjDBqPoh9O+0eGTFVwn2\n" \
          "qZf2iSLDKBOiha1wwzpTiiJV368CAwEAAaNQME4wHQYDVR0OBBYEFDfN1Tlj7wbn\n" \
          "JIemBNO1XrUOikQpMB8GA1UdIwQYMBaAFDfN1Tlj7wbnJIemBNO1XrUOikQpMAwG\n" \
          "A1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBACzXPSHet7aZrQvMUN03jOqq\n" \
          "w37brCWZ+L/+pbdOugVRAQRb2W+Z6gyrJ2BuUuiZLCXpjvXACSpwcSB3JesWs9KE\n" \
          "YO8E8ofF7a6ORvi2Mw0vpBbwJLqnci1gVlAj3X8r/VbX2rGbvRy+BJAF769xr43X\n" \
          "dtns0JIWwKud0xC3iRPMnewo/75HIblbN3guePfouoR2VgfBmeU72UR8O+OpjwbF\n" \
          "vpidobGqTGvZtxRV5axer69WY0rAXRhTSfkvyGTXERCJ3vdsF/v9iNKHhERUnpV6\n" \
          "KDrfvgD9uqWH12/89hfsfVN6iRH9UOE+SKoR/jHtvLMhVHpa80HVK1qdlfqUTZo=\n" \
          "-----END CERTIFICATE-----\n"
      }.freeze

      WEBPAY_NORMAL_TEST_PRIVATE_KEY = "-----BEGIN RSA PRIVATE KEY-----\n" \
      "MIIEowIBAAKCAQEAvuNgBxMAOBlNI7Fw5sHGY1p6DB6EMK83SL4b1ZILSJs/8/MC\n" \
      "X8Pkys3CvJmSIiKU7fnWkgXchEdqXJV+tzgoED/y99tXgoMssi0ma+u9YtPvpT7B\n" \
      "a5rk5HpLuaFNeuE3l+mpkXDZZKFSZJ1fV/Hyn3A1Zz+7+X2qiGrAWWdjeGsIkz4r\n" \
      "uuMFLQVdPVrdAxEWoDRybEUhraQJ1kwmx92HFfRlsbNAmEljG9ngx/+/JLA28cs9\n" \
      "oULy4/M7fVUzioKsBJmjRJd6s4rI2YIDpul6dmgloWgEfzfLNnAsZhJryJNBr2Wb\n" \
      "E6DL5x/U2XQchjishMbDIPjmDgS0HLLMjRCMpQIDAQABAoIBAEkSwa/zliHjjaQc\n" \
      "SRwNEeT2vcHl7LS2XnN6Uy1uuuMQi2rXnBEM7Ii2O9X28/odQuXWvk0n8UKyFAVd\n" \
      "NSTuWmfeEyTO0rEjhfivUAYAOH+coiCf5WtL4FOWfWaSWRaxIJcG2+LRUGc1WlUp\n" \
      "6VXBSR+/1LGxtEPN13phY0DWUz3FEfGBd4CCPLpzq7HyZWEHUvbaw89xZJSr/Zwh\n" \
      "BDZZyTbuwSHc9X9LlQsbaDuW/EyOMmDvSxmSRJO10FRMxyg8qbE4edtUK4jd61i0\n" \
      "kGFqdDu9sj5k8pDxOsN2F270SMlIwejZ1uunB87w9ezIcR9YLq9aa22cT8BZdOxb\n" \
      "uZ3PAAECgYEA6xfgRtcvpJUBWBVNsxrSg6Ktx2848eQne9NnbWHdZuNjH8OyN7SW\n" \
      "Fn0r4HsTw59/NJ1L5F3co5L5baEtRbRLWRpD72xjrXsQSsoKliCik1xgDIplMvOh\n" \
      "teA2GdeSv9wglqnotGcj5B/8+vn3tEzMjy+UUsyFn0fIaDC3zK3W2qUCgYEAz90g\n" \
      "va+FCcU8cnykb5Yn1u1izdK1c6S++v1bQFf6590ZMNy3p0uGrwAk/MzuBkJ421GK\n" \
      "p4pInUvO/Mb2BCcoHtr3ON3v0DCLl6Ae2Gb7lG0dLgcZ1EK7MDpMvKCqNHAv8Qu8\n" \
      "QBZOA08L8buVkkRt7jxJrPuOFDI5JAaWCmMOSgECgYEA3GvzfZgu9Go862B2DJL+\n" \
      "hCuYMiCHTM01c/UfyT/z/Y7/ln2+8FniS02rQPtE6ar28tb0nDahM8EPGon/T5ae\n" \
      "+vkUbzy6LKLxAJ501JPeurnm2Hs+LUqe+U8yioJD9p2m9Hx0UglOborLgGm0pRlI\n" \
      "xou+zu8x7ci5D292NXNcun0CgYAVKV378bKJnBrbTPUwpwjHSMOWUK1IaK1IwCJa\n" \
      "GprgoBHAd7f6wCWmC024ruRMntfO/C4xgFKEMQORmG/TXGkpOwGQOIgBme+cMCDz\n" \
      "xwg1xCYEWZS3l1OXRVgqm/C4BfPbhmZT3/FxRMrigUZo7a6DYn/drH56b+KBWGpO\n" \
      "BGegAQKBgGY7Ikdw288DShbEVi6BFjHKDej3hUfsTwncRhD4IAgALzaatuta7JFW\n" \
      "NrGTVGeK/rE6utA/DPlP0H2EgkUAzt8x3N0MuVoBl/Ow7y5sqIQKfEI7h0aRdXH5\n" \
      "ecefOL6iiJWQqX2+237NOd0fJ4E1+BCMu/+HnyCX+cFM2FgoE6tC\n" \
      "-----END RSA PRIVATE KEY-----\n".freeze

      WEBPAY_NORMAL_TEST_CERT = "-----BEGIN CERTIFICATE-----\n" \
      "MIIDeDCCAmACCQDjtGVIe/aeCTANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJj\n" \
      "bDENMAsGA1UECAwEc3RnbzENMAsGA1UEBwwEc3RnbzEMMAoGA1UECgwDdGJrMQ0w\n" \
      "CwYDVQQLDARjY3JyMRUwEwYDVQQDDAw1OTcwMjAwMDA1NDAxHTAbBgkqhkiG9w0B\n" \
      "CQEWDmNjcnJAZ21haWwuY29tMB4XDTE4MDYwODEzNDYwNloXDTIyMDYwNzEzNDYw\n" \
      "NlowfjELMAkGA1UEBhMCY2wxDTALBgNVBAgMBHN0Z28xDTALBgNVBAcMBHN0Z28x\n" \
      "DDAKBgNVBAoMA3RiazENMAsGA1UECwwEY2NycjEVMBMGA1UEAwwMNTk3MDIwMDAw\n" \
      "NTQwMR0wGwYJKoZIhvcNAQkBFg5jY3JyQGdtYWlsLmNvbTCCASIwDQYJKoZIhvcN\n" \
      "AQEBBQADggEPADCCAQoCggEBAL7jYAcTADgZTSOxcObBxmNaegwehDCvN0i+G9WS\n" \
      "C0ibP/PzAl/D5MrNwryZkiIilO351pIF3IRHalyVfrc4KBA/8vfbV4KDLLItJmvr\n" \
      "vWLT76U+wWua5OR6S7mhTXrhN5fpqZFw2WShUmSdX1fx8p9wNWc/u/l9qohqwFln\n" \
      "Y3hrCJM+K7rjBS0FXT1a3QMRFqA0cmxFIa2kCdZMJsfdhxX0ZbGzQJhJYxvZ4Mf/\n" \
      "vySwNvHLPaFC8uPzO31VM4qCrASZo0SXerOKyNmCA6bpenZoJaFoBH83yzZwLGYS\n" \
      "a8iTQa9lmxOgy+cf1Nl0HIY4rITGwyD45g4EtByyzI0QjKUCAwEAATANBgkqhkiG\n" \
      "9w0BAQsFAAOCAQEAhX2/fZ6+lyoY3jSU9QFmbL6ONoDS6wBU7izpjdihnWt7oIME\n" \
      "a51CNssla7ZnMSoBiWUPIegischx6rh8M1q5SjyWYTvnd3v+/rbGa6d40yZW3m+W\n" \
      "p/3Sb1e9FABJhZkAQU2KGMot/b/ncePKHvfSBzQCwbuXWPzrF+B/4ZxGMAkgxtmK\n" \
      "WnWrkcr2qakpHzERn8irKBPhvlifW5sdMH4tz/4SLVwkek24Sp8CVmIIgQR3nyR9\n" \
      "8hi1+Iz4O1FcIQtx17OvhWDXhfEsG0HWygc5KyTqCkVBClVsJPRvoCSTORvukcuW\n" \
      "18gbYO3VlxwXnvzLk4aptC7/8Jq83XY8o0fn+A==\n" \
      "-----END CERTIFICATE-----\n".freeze

      # Returns a Configuration object ready to be used
      def self.for_testing_webpay_plus_normal
        config = Configuration.new
        config.environment = ::Transbank::Webpay::Webpay.environments[:TEST]
        config.private_key = WEBPAY_NORMAL_TEST_PRIVATE_KEY
        config.public_cert = WEBPAY_NORMAL_TEST_CERT
        config.webpay_cert = DEFAULT_WEBPAY_CERTS[:TEST]
        config.commerce_code = '597020000540'
        config
      end
    end
  end
end
