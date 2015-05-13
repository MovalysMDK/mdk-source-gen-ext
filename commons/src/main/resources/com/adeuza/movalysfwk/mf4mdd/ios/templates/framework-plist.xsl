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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:output method="xml" />

<!-- 
doctype-system="http://www.apple.com/DTDs/PropertyList-1.0.dtd"
	doctype-public="-//Apple//DTD PLIST 1.0//EN"
	 -->

<xsl:template match="frameworkConfig"><plist version="1.0">
<dict>

  	<key>Menu_<xsl:value-of select="mainStoryboardConfig/name"/></key>
  		<array>
  		<xsl:for-each select="mainStoryboardConfig/navigation">
  			<string>nav_<xsl:value-of select="."/></string>
  		</xsl:for-each>
  		</array>
  	<xsl:for-each select="storyboardConfig">
  		<key>Menu_<xsl:value-of select="name"/></key>
  		<array>
  		<xsl:for-each select="navigation">
  			<string>nav_<xsl:value-of select="."/></string>
  		</xsl:for-each>
  		</array>
  	</xsl:for-each>
  
   <key>MainStoryboard</key>
	<string><xsl:value-of select="mainStoryboardConfig/name"/></string>
	
	
</dict>
</plist>
</xsl:template>

</xsl:stylesheet>
