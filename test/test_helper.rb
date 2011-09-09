require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

require File.expand_path('../../lib/enom',   __FILE__)

class Test::Unit::TestCase

  FakeWeb.allow_net_connect = false

  commands = [
    {
      :command => "SetHosts",
      :request => "https://reseller.enom.com/interface.asp?Command=SetHosts&SLD=test123456test123456&TLD=com&Address1=123.123.123.123&HostName1=test123456test123456.com&RecordType1=A&UID=resellid&PW=resellpw&ResponseType=xml",
      :response => <<-EOF      
        <?xml version="1.0" ?> 
        <interface-response>
          <DomainRRP>E</DomainRRP> 
          <Command>SETHOSTS</Command> 
          <ErrCount>0</ErrCount>
          <Server>Dev Workstation</Server> 
          <Site>enom</Site> 
          <IsLockable>True</IsLockable> 
          <IsRealTimeTLD>True</IsRealTimeTLD> 
          <Done>true</Done>
          <debug> 
             <![CDATA[  ]]> 
          </debug>
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
                 <domain name="handsewncurtains" com="n" comscore="835" net="y" netscore="864" tv="y" tvscore="797" cc="y" ccscore="762" /> 
                 <domain name="handicappingclub" com="n" comscore="821" net="y" netscore="851" tv="y" tvscore="784" cc="y" ccscore="749" /> 
                 <domain name="handingok" com="y" comscore="837" net="y" netscore="810" tv="y" tvscore="783" cc="y" ccscore="757" /> 
                 <domain name="handsofjustice" com="n" comscore="870" net="n" netscore="844" tv="y" tvscore="834" cc="y" ccscore="799" /> 
                 <domain name="handoki" com="n" comscore="794" net="y" netscore="824" tv="y" tvscore="757" cc="y" ccscore="722" /> 
                 <domain name="handinghand" com="y" comscore="820" net="y" netscore="793" tv="y" tvscore="767" cc="y" ccscore="740" /> 
                 <domain name="handcrafthouselogs" com="y" comscore="810" net="y" netscore="783" tv="y" tvscore="757" cc="y" ccscore="730" /> 
                 <domain name="handloser" com="n" comscore="844" net="n" netscore="817" tv="y" tvscore="807" cc="y" ccscore="773" /> 
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
