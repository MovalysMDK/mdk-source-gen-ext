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

<xsl:output method="xml" indent="yes"/>

<!-- Floating Action Button -->
<xsl:template match="button" mode="fab">
	<xsl:text disable-output-escaping="yes"><![CDATA[
	<]]>android.support.design.widget.FloatingActionButton</xsl:text>
	<xsl:text> android:id="@+id/</xsl:text>
	<xsl:value-of select="./@name"/><xsl:text>"</xsl:text>
	<xsl:apply-templates select="." mode="dimensions-wrap"/> 
	<xsl:text> android:src="@android:drawable/ic_input_add"</xsl:text>
	<xsl:text> android:layout_centerHorizontal="true"</xsl:text>
	<xsl:text> android:layout_gravity="bottom|end"</xsl:text>
	<xsl:text> android:layout_margin="16dp"</xsl:text>
	<xsl:text disable-output-escaping="yes"><![CDATA[/>]]></xsl:text>
</xsl:template>

<!-- Action button -->
<xsl:template match="button">
	<xsl:text disable-output-escaping="yes"><![CDATA[
	<]]></xsl:text>
	<xsl:apply-templates select="."  mode="buttonType"/>
	<xsl:text> android:id="@+id/</xsl:text>
	<xsl:value-of select="./@name"/><xsl:text>"</xsl:text>
	<xsl:apply-templates select="." mode="dimensions-wrap"/> 
	<xsl:apply-templates select="." mode="buttonOptions"/>
	<xsl:text disable-output-escaping="yes"><![CDATA[/>]]></xsl:text>
</xsl:template>


<!-- Component type for action button of type 'NAVIGATION'-->
<xsl:template match="button[@type='NAVIGATION']" mode="buttonType">
	<xsl:text>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMActionButton</xsl:text>
</xsl:template>


<!-- Default Component type for action button-->
<xsl:template match="button" mode="buttonType">
	<xsl:text>com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMActionImageButton</xsl:text>
</xsl:template>

	<!--Default style for Action image button-->
	<xsl:template match="visualfield[component = 'com.adeuza.movalysfwk.mobile.mf4android.ui.views.MMActionImageButton']" mode="componentStyle">
		<xsl:text>ActionButton</xsl:text>
	</xsl:template>

<!-- Options for action button of type NAVIGATION -->
<xsl:template match="button[@type='NAVIGATION']" mode="buttonOptions">
	<xsl:text>android:text="@string/</xsl:text><xsl:value-of select="./@label-id"/><xsl:text>"</xsl:text>
	<xsl:text> android:layout_centerHorizontal="true"</xsl:text>
	<!-- NAVIGATION buttons are aligned vertically -->
	<xsl:variable name="previous-button" select="preceding-sibling::button[@type='NAVIGATION']"/>
	<xsl:if test="count($previous-button) > 0">
		<xsl:text> android:layout_below="@id/</xsl:text>
		<xsl:value-of select="$previous-button[position() = last()]/@name"/>
		<xsl:text>"</xsl:text>
	</xsl:if>
	<xsl:apply-templates select="navigation"/>
</xsl:template>

<!-- Default options for action button -->
<xsl:template match="button" mode="buttonOptions">
	<xsl:text>android:src="@drawable/</xsl:text>
	<xsl:choose>
		<xsl:when test="@type='SAVE'">
			<xsl:text>ic_btn_ok</xsl:text>
		</xsl:when>
		<xsl:when test="@type='DELETE'">
			<xsl:text>ic_btn_delete</xsl:text>
		</xsl:when>
		<xsl:when test="@type='CANCEL'">
			<xsl:text>ic_btn_cancel</xsl:text>
		</xsl:when>
	</xsl:choose>
	<xsl:text>" </xsl:text>
	<xsl:if test="count(preceding-sibling::button) > 0">
		<xsl:text>android:layout_toRightOf="@id/</xsl:text>
		<xsl:value-of select="preceding-sibling::button[1]/@name"/>
		<xsl:text>"
		</xsl:text>
	</xsl:if>
	<xsl:if test="count(../../visualfields/visualfield)>0">
		android:layout_below="@id/<xsl:value-of select="../../visualfields/visualfield[count(../../visualfields/visualfield)]/name"/>"
	</xsl:if>
	<xsl:text>movalys:action="</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
	
</xsl:template>

<xsl:template match="navigation">
	<xsl:text> movalys:activityForResult="</xsl:text><xsl:value-of select="target/full-name"/><xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="navigation[@type='NAVIGATION_WKS_SWITCHPANEL' and @name='navigation-oncreate' and @internal='true']">
	<xsl:text> movalys:methodToLaunch="doOnCreate"</xsl:text>
</xsl:template>

</xsl:stylesheet>