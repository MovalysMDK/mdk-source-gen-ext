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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:android="http://schemas.android.com/apk/res/android"
	exclude-result-prefixes="xalan">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" xalan:indent-amount="2"/>	

<xsl:template match="screens/screen">

<activity >
	<xsl:attribute name="android:name">
		<xsl:value-of select="./full-name"/>
	</xsl:attribute>
	<xsl:attribute name="android:label">
		<xsl:text>@string/</xsl:text><xsl:value-of select="./name"/>
	</xsl:attribute>
	<xsl:attribute name="android:windowSoftInputMode">
		<xsl:text>adjustPan</xsl:text>
	</xsl:attribute>
		
	<xsl:if test="./main='true'">
		<intent-filter>
			<action>
				<xsl:attribute name="android:name">
					<xsl:value-of select="../@root-package"/>
					<xsl:text>.action.PROJECT_MAIN</xsl:text>
				</xsl:attribute>
			</action>
			<category>
				<xsl:attribute name="android:name">
					<xsl:value-of select="../@root-package"/>
					<xsl:text>.category.MF4A</xsl:text>
				</xsl:attribute>
			</category>
	    	<category>
	    		<xsl:attribute name="android:name">
	    			<xsl:text>android.intent.category.DEFAULT</xsl:text>
	    		</xsl:attribute>
	    	</category>
		</intent-filter>
	</xsl:if>
</activity>

</xsl:template>

</xsl:stylesheet>