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
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt">

	<xsl:output method="xml" indent="yes" xalan:indent-amount="4" />

	<xsl:template match="menu">

		<menu xmlns:android="http://schemas.android.com/apk/res/android"
			xmlns:mdkapp="http://schemas.android.com/apk/res-auto">
			<xsl:text disable-output-escaping="yes">&#13;&#13;</xsl:text>

			<xsl:apply-templates select="menu-item" mode="resmenu" />

			<!-- <xsl:for-each select="./menu-item">
				<xsl:text disable-output-escaping="yes"><![CDATA[<item android:id="@+id/]]></xsl:text>
				<xsl:value-of select="@id" />
				<xsl:text disable-output-escaping="yes">"&#13;</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[ android:icon="@drawable/ic_menu_refresh"]]></xsl:text>
					TODO: icon
				<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
				<xsl:text disable-output-escaping="yes"><![CDATA[ android:title="@string/application_]]></xsl:text>
				<xsl:value-of select="@id" />
				<xsl:text disable-output-escaping="yes"><![CDATA[" />]]></xsl:text>
				<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
			</xsl:for-each> -->
			<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
		</menu>

	</xsl:template>

	<xsl:template match="menu-item[action-provider]" mode="resmenu">
		<xsl:text disable-output-escaping="yes"><![CDATA[<item android:id="@+id/]]></xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text disable-output-escaping="yes">"&#13;</xsl:text>
		<xsl:choose>
			<xsl:when test="action-provider/type='DELETEDETAIL'">
				<xsl:text disable-output-escaping="yes"><![CDATA[ android:icon="@android:drawable/ic_menu_delete"]]></xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes"><![CDATA[ android:icon="@android:drawable/ic_menu_save"]]></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ mdkapp:showAsAction="ifRoom"]]></xsl:text>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ android:orderInCategory="1"]]>&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ />]]></xsl:text>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="menu-item[button/navigation]" mode="resmenu">
		<xsl:text disable-output-escaping="yes"><![CDATA[<item android:id="@+id/]]></xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text disable-output-escaping="yes">"&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ android:icon="@android:drawable/ic_menu_add"]]></xsl:text>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ android:title="@string/application_]]></xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text disable-output-escaping="yes">"&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[mdkapp:showAsAction="always"]]></xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ />]]></xsl:text>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="menu-item" mode="resmenu">
		<xsl:text disable-output-escaping="yes"><![CDATA[<item android:id="@+id/]]></xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text disable-output-escaping="yes">"&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ android:icon="@drawable/ic_menu_refresh"]]></xsl:text><!-- 
			TODO: icon -->
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
		<xsl:text disable-output-escaping="yes"><![CDATA[ android:title="@string/application_]]></xsl:text>
		<xsl:value-of select="@id" />
		<xsl:text disable-output-escaping="yes"><![CDATA[" />]]></xsl:text>
		<xsl:text disable-output-escaping="yes">&#13;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
