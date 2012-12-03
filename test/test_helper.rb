require "rubygems"
require "test/unit"
require "shoulda"
require "fakeweb"

require File.expand_path("../../lib/enom",   __FILE__)

class Test::Unit::TestCase

  FakeWeb.allow_net_connect = false

  commands = [
    {
      :command => "Purchase (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=Purchase&SLD=test123456test123456&TLD=com&UseDNS=default&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <OrderID>157609741</OrderID>
          <TotalCharged>15</TotalCharged>
          <RegistrantPartyID>{CF869235-0083-4BB0-99DF-DCEAC6F2294E}</RegistrantPartyID>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully - 157609741</RRPText>
          <Command>PURCHASE</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>2.938</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Purchase (with attrs)",
      :request => "https://reseller.enom.com/interface.asp?Command=Purchase&SLD=test123456test123456&TLD=com&UseDNS=default&RegistrantFirstName=Test&RegistrantLastName=Tester&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <OrderID>157609741</OrderID>
          <TotalCharged>15</TotalCharged>
          <RegistrantPartyID>{CF869235-0083-4BB0-99DF-DCEAC6F2294E}</RegistrantPartyID>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully - 157609741</RRPText>
          <Command>PURCHASE</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>2.938</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Check (Failure)",
      :request => "https://reseller.enom.com/interface.asp?Command=Check&SLD=google&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <DomainName>google.com</DomainName>
          <RRPCode>211</RRPCode>
          <RRPText>Domain not available</RRPText>
          <AuctionDate/>
          <AuctionID/>
          <Command>CHECK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>0.625</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Check (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=Check&SLD=test123456test123456&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <DomainName>test123456test123456.com</DomainName>
          <RRPCode>210</RRPCode>
          <RRPText>Domain available</RRPText>
          <AuctionDate/>
          <AuctionID/>
          <Command>CHECK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>0.672</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Check Many with default (*) TLD list (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=Check&SLD=test123456test123456&TLD=*&TLDList=&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <Domain1>test123456test123456.com</Domain1>
          <RRPCode1>210</RRPCode1>
          <RRPText1>Domain available</RRPText1>
          <Domain2>test123456test123456.net</Domain2>
          <RRPCode2>210</RRPCode2>
          <RRPText2>Domain available</RRPText2>
          <Domain3>test123456test123456.org</Domain3>
          <RRPCode3>210</RRPCode3>
          <RRPText3>Domain available</RRPText3>
          <Domain4>test123456test123456.info</Domain4>
          <RRPCode4>210</RRPCode4>
          <RRPText4>Domain available</RRPText4>
          <Domain5>test123456test123456.biz</Domain5>
          <RRPCode5>210</RRPCode5>
          <RRPText5>Domain available</RRPText5>
          <Domain6>test123456test123456.ws</Domain6>
          <RRPCode6>210</RRPCode6>
          <RRPText6>Domain available</RRPText6>
          <Domain7>test123456test123456.us</Domain7>
          <RRPCode7>210</RRPCode7>
          <RRPText7>Domain available</RRPText7>
          <Domain8>test123456test123456.cc</Domain8>
          <RRPCode8>210</RRPCode8>
          <RRPText8>Domain available</RRPText8>
          <Domain9>test123456test123456.tv</Domain9>
          <PremiumName>
            <IsPremiumName>False</IsPremiumName>
            <PremiumPrice/>
            <PremiumAboveThresholdPrice>False</PremiumAboveThresholdPrice>
            <PremiumCategory>False</PremiumCategory>
          </PremiumName>
          <RRPCode9>210</RRPCode9>
          <RRPText9>Domain available</RRPText9>
          <Domain10>test123456test123456.bz</Domain10>
          <RRPCode10>210</RRPCode10>
          <RRPText10>Domain available</RRPText10>
          <Domain11>test123456test123456.nu</Domain11>
          <RRPCode11>210</RRPCode11>
          <RRPText11>Domain available</RRPText11>
          <Domain12>test123456test123456.mobi</Domain12>
          <RRPCode12>210</RRPCode12>
          <RRPText12>Domain available</RRPText12>
          <Domain13>test123456test123456.eu</Domain13>
          <RRPCode13>210</RRPCode13>
          <RRPText13>Domain available</RRPText13>
          <Domain14>test123456test123456.ca</Domain14>
          <RRPCode14>210</RRPCode14>
          <RRPText14>Domain available</RRPText14>
          <DomainCount>14</DomainCount>
          <Command>CHECK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>SJL01WRESELL15</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+00.00</TimeDifference>
          <ExecTime>2.156</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Check Many with custom array TLD list (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=Check&SLD=test123456test123456&TLD=&TLDList=us%2Cca%2Ccom&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <Domain>test123456test123456.us</Domain>
          <RRPCode>210</RRPCode>
          <RRPText>Domain available</RRPText>
          <Domain>test123456test123456.ca</Domain>
          <RRPCode>210</RRPCode>
          <RRPText>Domain available</RRPText>
          <Domain>test123456test123456.com</Domain>
          <RRPCode>210</RRPCode>
          <RRPText>Domain available</RRPText>
          <DomainCount>3</DomainCount>
          <AuctionDate/>
          <AuctionID/>
          <Command>CHECK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod/>
          <MaxPeriod>10</MaxPeriod>
          <Server>SJL01WRESELL06</Server>
          <Site>eNom</Site>
          <IsLockable/>
          <IsRealTimeTLD/>
          <TimeDifference>+0.00</TimeDifference>
          <ExecTime>0.344</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "GetDomainInfo (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=GetDomainInfo&SLD=test123456test123456&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <GetDomainInfo>
            <domainname sld="test123456test123456" tld="com" domainnameid="340724808">test123456test123456.com</domainname>
            <multy-langSLD>
        </multy-langSLD>
            <status>
              <expiration>1/30/2012 5:23:00 PM</expiration>
              <escrowliftdate/>
              <escrowhold/>
              <deletebydate>1/30/2012 5:23:00 PM</deletebydate>
              <deletetype/>
              <registrar>eNom, Inc.</registrar>
              <registrationstatus>Registered</registrationstatus>
              <purchase-status>Paid</purchase-status>
              <belongs-to party-id="{CF869235-0083-4BB0-99DF-DCEAC6F2294E}">resellid</belongs-to>
            </status>
            <ParkingEnabled>False</ParkingEnabled>
            <services>
              <entry name="dnsserver">
                <enomDNS value="YES" isDotName="NO"/>
                <service changable="1">1006</service>
                <configuration changable="0" type="dns">
                  <dns>dns1.name-services.com</dns>
                  <dns>dns2.name-services.com</dns>
                  <dns>dns3.name-services.com</dns>
                  <dns>dns4.name-services.com</dns>
                  <dns>dns5.name-services.com</dns>
                </configuration>
              </entry>
              <entry name="dnssettings">
                <service changable="0">1021</service>
                <configuration changable="1" type="host">
                  <host>
                    <name><![CDATA[*]]></name>
                    <type><![CDATA[A]]></type>
                    <address><![CDATA[69.25.142.5]]></address>
                    <mxpref><![CDATA[10]]></mxpref>
                    <iseditable><![CDATA[1]]></iseditable>
                  </host>
                  <host>
                    <name><![CDATA[@]]></name>
                    <type><![CDATA[A]]></type>
                    <address><![CDATA[69.25.142.5]]></address>
                    <mxpref><![CDATA[10]]></mxpref>
                    <iseditable><![CDATA[1]]></iseditable>
                  </host>
                  <host>
                    <name><![CDATA[www]]></name>
                    <type><![CDATA[A]]></type>
                    <address><![CDATA[69.25.142.5]]></address>
                    <mxpref><![CDATA[10]]></mxpref>
                    <iseditable><![CDATA[1]]></iseditable>
                  </host>
                </configuration>
              </entry>
              <entry name="wsb">
                <service changable="1">1060</service>
              </entry>
              <entry name="emailset">
                <service changable="1">1048</service>
              </entry>
              <entry name="wpps">
                <service changable="1">1123</service>
              </entry>
              <entry name="wbl">
                <wbl>
                  <statusid><![CDATA[0]]></statusid>
                  <statusdescr><![CDATA[Available]]></statusdescr>
                </wbl>
              </entry>
              <entry name="mobilizer">
                <service changable="0">1117</service>
                <mobilizer/>
              </entry>
              <entry name="parking">
                <service changable="1">1033</service>
              </entry>
              <entry name="messaging">
                <service changable="1">1087</service>
              </entry>
              <entry name="map">
                <service changable="1">1108</service>
              </entry>
            </services>
          </GetDomainInfo>
          <Command>GETDOMAININFO</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>0.344</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Extend (Success)",
      :request => "https://reseller.enom.com/interface.asp?Command=Extend&SLD=test123456test123456&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <Extension>successful</Extension>
          <DomainName>test123456test123456.com</DomainName>
          <OrderID>157609742</OrderID>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully</RRPText>
          <Command>EXTEND</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>1.453</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "GetBalance",
      :request => "https://reseller.enom.com/interface.asp?Command=GetBalance&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <Reseller>1</Reseller>
          <Balance>3,709.20</Balance>
          <AvailableBalance>3,669.40</AvailableBalance>
          <DomainCount>74</DomainCount>
          <Command>GETBALANCE</Command>
          <ErrCount>0</ErrCount>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "GetRegLock",
      :request => "https://reseller.enom.com/interface.asp?Command=GetRegLock&SLD=test123456test123456&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <reg-lock>1</reg-lock>
          <registrar>E</registrar>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully</RRPText>
          <Command>GETREGLOCK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>0.375</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "SetRegLock",
      :request => "https://reseller.enom.com/interface.asp?Command=SetRegLock&SLD=test123456test123456&TLD=com&UnlockRegistrar=1&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <RegistrarLock>ACTIVE</RegistrarLock>
          <RRPCodeSR>200</RRPCodeSR>
          <RRPText>Command completed successfully</RRPText>
          <Command>SETREGLOCK</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>1.016</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "ModifyNS",
      :request => "https://reseller.enom.com/interface.asp?Command=ModifyNS&SLD=test123456test123456&TLD=com&NS1=ns1.foo.com&NS2=ns2.foo.com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <reg-lock>0</reg-lock>
          <registrar>E</registrar>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully</RRPText>
          <Command>MODIFYNS</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>1.594</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "Transfer domain",
      :request => "https://reseller.enom.com/interface.asp?Command=TP_CreateOrder&OrderType=AutoVerification&DomainCount=1&SLD1=resellerdocs2&TLD1=net&AuthInfo1=ros8enQi&UseContacts=1&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <success>True</success>
          <transferorder>
          <transferorderid>175614452</transferorderid>
          <orderdate>9/7/2011 10:59:21 AM</orderdate>
          <ordertypeid>1</ordertypeid>
          <ordertypedesc>Auto Verification</ordertypedesc>
          <statusid>4</statusid>
          <statusdesc>Processing</statusdesc>
          <authamount>8.95</authamount>
          <version>1</version>
          <transferorderdetail>
          <transferorderdetailid>77455163</transferorderdetailid>
          <sld>resellerdocs2</sld>
          <tld>net</tld>
          <statusid>9</statusid>
          <statusdesc>Awaiting auto verification of transfer request</statusdesc>
          <price>8.95</price>
          <usecontacts>1</usecontacts>
          </transferorderdetail>
          <transferorderdetailcount>1</transferorderdetailcount>
          </transferorder>
          <success>True</success>
          <Command>TP_CREATEORDER</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>SJL21WRESELLT01</Server>
          <Site>eNom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+08.00</TimeDifference>
          <ExecTime>0.563</ExecTime>
          <Done>true</Done>
          <debug>
          <![CDATA[ ]]>
          </debug>
        </interface-response>
      EOF
    },
    {
      :command => "GetAllDomains",
      :request => "https://reseller.enom.com/interface.asp?Command=GetAllDomains&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <GetAllDomains>
            <DomainDetail>
              <DomainName>test1234567test1234567.com</DomainName>
              <DomainNameID>340724808</DomainNameID>
              <expiration-date>1/30/2012 5:23:00 PM</expiration-date>
              <lockstatus>Locked</lockstatus>
              <AutoRenew>No</AutoRenew>
            </DomainDetail>
            <DomainDetail>
              <DomainName>test123456test123456.com</DomainName>
              <DomainNameID>340724807</DomainNameID>
              <expiration-date>1/30/2013 5:21:00 PM</expiration-date>
              <lockstatus>Locked</lockstatus>
              <AutoRenew>No</AutoRenew>
            </DomainDetail>
            <domaincount>2</domaincount>
            <UserRequestStatus>DomainBox</UserRequestStatus>
          </GetAllDomains>
          <Command>GETALLDOMAINS</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod/>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>eNom</Site>
          <IsLockable/>
          <IsRealTimeTLD/>
          <TimeDifference>+0.00</TimeDifference>
          <ExecTime>0.156</ExecTime>
          <Done>true</Done>
          <debug><![CDATA[]]></debug>
        </interface-response>
      EOF
    },
    {
      :command => "NameSpinner",
      :request => "https://reseller.enom.com/interface.asp?Command=namespinner&SLD=hand&TLD=com&MaxResults=8&Similar=High&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
           <namespin>
              <spincount>8</spincount>
              <TLDList />
              <domains>
                 <domain name="Handsewncurtains" com="n" comscore="835" net="y" netscore="864" tv="y" tvscore="797" cc="y" ccscore="762" />
                 <domain name="Handicappingclub" com="n" comscore="821" net="y" netscore="851" tv="y" tvscore="784" cc="y" ccscore="749" />
                 <domain name="Handingok" com="y" comscore="837" net="y" netscore="810" tv="y" tvscore="783" cc="y" ccscore="757" />
                 <domain name="Handsofjustice" com="n" comscore="870" net="n" netscore="844" tv="y" tvscore="834" cc="y" ccscore="799" />
                 <domain name="Handoki" com="n" comscore="794" net="y" netscore="824" tv="y" tvscore="757" cc="y" ccscore="722" />
                 <domain name="Handinghand" com="y" comscore="820" net="y" netscore="793" tv="y" tvscore="767" cc="y" ccscore="740" />
                 <domain name="Handcrafthouselogs" com="y" comscore="810" net="y" netscore="783" tv="y" tvscore="757" cc="y" ccscore="730" />
                 <domain name="Handloser" com="n" comscore="844" net="n" netscore="817" tv="y" tvscore="807" cc="y" ccscore="773" />
              </domains>
           </namespin>
           <originalsld>hand</originalsld>
           <Command>NAMESPINNER</Command>
           <Language>eng</Language>
           <ErrCount>0</ErrCount>
           <ResponseCount>0</ResponseCount>
           <MinPeriod>1</MinPeriod>
           <MaxPeriod>10</MaxPeriod>
           <Server>RESELLER1-STG</Server>
           <Site>enom</Site>
           <IsLockable>True</IsLockable>
           <IsRealTimeTLD>True</IsRealTimeTLD>
           <TimeDifference>+03.00</TimeDifference>
           <ExecTime>0.719</ExecTime>
           <Done>true</Done>
           <debug>
              <![CDATA[  ]]>
           </debug>
        </interface-response>
      EOF
    },
    {
      :command => "DeleteRegistration",
      :request => "https://reseller.enom.com/interface.asp?Command=DeleteRegistration&SLD=resellerdocs3&TLD=com&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <deletedomain>
            <domaindeleted>True</domaindeleted>
          </deletedomain>
          <ErrString/>
          <ErrSource/>
          <ErrSection>DELETEREGISTRATION</ErrSection>
          <RRPCode>200</RRPCode>
          <RRPText>Command completed successfully</RRPText>
          <Command>DELETEREGISTRATION</Command>
          <Language>eng</Language>
          <ErrCount>0</ErrCount>
          <ResponseCount>0</ResponseCount>
          <MinPeriod>1</MinPeriod>
          <MaxPeriod>10</MaxPeriod>
          <Server>RESELLERTEST</Server>
          <Site>enom</Site>
          <IsLockable>True</IsLockable>
          <IsRealTimeTLD>True</IsRealTimeTLD>
          <TimeDifference>+03.00</TimeDifference>
          <ExecTime>2.75</ExecTime>
          <Done>true</Done>
          <debug>
            [CDATA ]
          </debug>
        </interface-response>
      EOF
    },
    {
      :command => "SynchAuthInfo",
      :request => "https://reseller.enom.com/interface.asp?Command=SynchAuthInfo&SLD=test123456test123456&TLD=com&RunSynchAutoInfo=1&EmailEPP=1&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF
        <?xml version="1.0"?>
        <interface-response>
          <InfoSynched>True</InfoSynched> 
          <EPPEmailMessage>Email has been sent.</EPPEmailMessage> 
          <Command>SYNCHAUTHINFO</Command> 
          <Language>eng</Language> 
          <ErrCount>0</ErrCount> 
          <ResponseCount>0</ResponseCount> 
          <MinPeriod>1</MinPeriod> 
          <MaxPeriod>10</MaxPeriod> 
          <Server>RESELLER1-STG</Server> 
          <Site>enom</Site> 
          <IsLockable>True</IsLockable> 
          <IsRealTimeTLD>True</IsRealTimeTLD> 
          <TimeDifference>+03.00</TimeDifference> 
          <ExecTime>1.715</ExecTime> 
          <Done>true</Done> 
          <debug><![CDATA[  ]]></debug>
        </interface-response>
      EOF
    }

  ]

  commands.each do |c|
    FakeWeb.register_uri(
      :get,
      c[:request],
      :body => c[:response],
      :content_type => "application/xml",
      :status => ["200", "OK"]
    )
  end

end
