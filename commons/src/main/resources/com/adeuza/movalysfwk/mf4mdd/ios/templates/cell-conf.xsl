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

<xsl:output method="xml"/>

<xsl:include href="ui/storyboard/views/view-mftextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfposition.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfsendmailtextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfbrowseurltextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfcallphonenumber.xsl"/>
<xsl:include href="ui/storyboard/views/view-mflabel.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfsimplepickerlist.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfdoubletextfield.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfphotothumbnail.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfdatepicker.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfslider.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfswitch.xsl"/>
<xsl:include href="ui/storyboard/views/view-mfscanner.xsl"/>



<xsl:template match="controller[@controllerType='LISTVIEW']">
<plist version="1.0">
	<dict>
		<key>configuration<xsl:value-of select="cellClassName"/></key>
		<dict>
			<key>height</key>
			<integer><xsl:value-of select="sections/section/@frameHeight"/></integer>
			
			<key>typeName</key>
			<string>MFConfigurationGroupDescriptor</string>
		</dict>
	</dict>
</plist>
</xsl:template>

<xsl:template match="controller[@controllerType='LISTVIEW2D']">
<plist version="1.0">
	<dict>
		<key>configuration<xsl:value-of select="cellClassName"/></key>
		<dict>
			<key>height</key>
			<integer><xsl:value-of select="sections/section[./sectionType = 'LISTCELL']/@frameHeight"/></integer>
			
			<key>typeName</key>
			<string>MFConfigurationGroupDescriptor</string>
		</dict>
	</dict>
</plist>
</xsl:template>


<xsl:template match="controller[@controllerType='FIXEDLISTVIEW']">
<plist version="1.0">
<dict>
	<key>configuration<xsl:value-of select="cellClassName"/></key>
	<dict>
		<key>height</key>
		<integer><xsl:value-of select="sections/section/@frameHeight"/></integer>

		<key>typeName</key>
		<string>MFConfigurationGroupDescriptor</string>
	</dict>
</dict>
</plist>
</xsl:template>


<xsl:template match="controller[@controllerType='COMBOVIEW']">
<plist version="1.0">
<dict>
	<key>configuration<xsl:value-of select="itemCellClassName"/></key>
	<dict>
		<key>height</key>
		<integer><xsl:value-of select="sections/section/@frameHeight"/></integer>

		<key>typeName</key>
		<string>MFConfigurationGroupDescriptor</string>
	</dict>
</dict>
</plist>
</xsl:template>


<!-- Cas de la pickerlist uniquement! filtre du template a detailler si d'autres formview doivent générer des confs
ATTENTION : On considère bien que ce controller de type FORMVIEW construit uniquement pour la génération de ce fichier 
de configuration, contient qu'une section ne contenant qu'une seule vue : le picker List.  -->
<xsl:template match="controller[@controllerType='FORMVIEW']">
<plist version="1.0">
<dict>
	<key>configuration<xsl:value-of select="//subView[1]/options/entry[@key = 'cell-selected-item-name']"/></key>
	<dict>
		<key>height</key>
		<integer><xsl:value-of select="sections/section/@frameHeight"/></integer>

		<key>typeName</key>
		<string>MFConfigurationGroupDescriptor</string>
	</dict>
</dict>
</plist>
</xsl:template>

</xsl:stylesheet>