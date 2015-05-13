<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)

    This file is part of Movalys MDK.
    Movalys MDK is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    Movalys MDK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU Lesser General Public License for more details.
    You should have received a copy of the GNU Lesser General Public License
    along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>

<xsl:template match="properties">
	<ArrayOfPropertiesValue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
		<xsl:apply-templates select="property" />
		<PropertiesValue>
			<Key>LogLevel</Key>
			<Value>
				<Value>1</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>LogMaxSize</Key>
			<Value>
				<Value>2</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>LogEnabled</Key>
			<Value>
				<Value>True</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>LogMaxFiles</Key>
			<Value>
				<Value>3</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>synchronization_max_time_without_sync</Key>
			<Value>
				<Value>1</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>sync_mock_testid</Key>
			<Value>
				<Value>200</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>sync_mock_mode</Key>
			<Value>
				<Value>false</Value>
			</Value>
		</PropertiesValue>
		<PropertiesValue>
			<Key>case_sensitive_login</Key>
			<Value>
				<Value>false</Value>
			</Value> 
		</PropertiesValue>
	</ArrayOfPropertiesValue>
</xsl:template>

<xsl:template match="property">
	<PropertiesValue>
		<Key><xsl:value-of select="./key"/></Key>
		<Value>
			<Value><xsl:value-of select="./value"/></Value>
		</Value>
	</PropertiesValue>
</xsl:template>

</xsl:stylesheet>