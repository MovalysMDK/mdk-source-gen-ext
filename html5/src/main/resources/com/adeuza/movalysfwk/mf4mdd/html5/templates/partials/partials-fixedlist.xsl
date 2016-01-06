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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes" omit-xml-declaration="no" />

	<xsl:include href="components/mfbrowseurltextfield.xsl" />
	<xsl:include href="components/mfbutton.xsl" />
	<xsl:include href="components/mfcallphonenumber.xsl" />
	<xsl:include href="components/mfdatepicker.xsl" />
	<xsl:include href="components/mfdoubletextfield.xsl" />
	<xsl:include href="components/mfenumimage.xsl" />
	<xsl:include href="components/mffixedlist.xsl" />
	<xsl:include href="components/mfintegertextfield.xsl" />
	<xsl:include href="components/mflabel.xsl" />
	<xsl:include href="components/mfnumberpicker.xsl"/>
	<xsl:include href="components/mfphotothumbnail.xsl" />
	<xsl:include href="components/mfpickerlist.xsl" />
	<xsl:include href="components/mfposition.xsl" />
	<xsl:include href="components/mfradiogroup.xsl" />
	<xsl:include href="components/mfsendmailtextfield.xsl" />
	<xsl:include href="components/mfsignature.xsl" />
	<xsl:include href="components/mfslider.xsl" />
	<xsl:include href="components/mfswitch.xsl" />
	<xsl:include href="components/mftextfield.xsl" />
	<xsl:include href="components/mftextview.xsl" />
	<xsl:include href="components/mfwebview.xsl" />
	<!-- list components -->
	<xsl:include href="components/mflist.xsl" />

	<xsl:template match="view">

		<xsl:variable name="fixedListName"><xsl:value-of select="fixedList"/></xsl:variable>


		<div class="modal-body" mf-stop-event="touchend">
			<xsl:text disable-output-escaping="yes"><![CDATA[<form ]]></xsl:text>
			<xsl:text>name="</xsl:text><xsl:value-of select="$fixedListName"/><xsl:text>Form"</xsl:text>
			<xsl:text disable-output-escaping="yes"><![CDATA[ novalidate>]]></xsl:text>

				<xsl:apply-templates
					select="attributes/HTML-attribute[visualfield/parameters/parameter[@name = 'fixedListVmPropertyName'] = $fixedListName]/detail-attributes/HTML-attribute"
					mode="partial-component-generation">
					<xsl:with-param name="viewModel">item</xsl:with-param>
				</xsl:apply-templates>

			<xsl:text disable-output-escaping="yes"><![CDATA[</form>]]></xsl:text>

		</div>

		<div class="modal-footer">
			<button type="button" ng-click="cancel()" class="btn btn-default btn-danger">
				<span class="glyphicon glyphicon-remove"></span>
			</button>
			<button type="button" ng-click="ok()" class="btn btn-default btn-success">
				<span class="glyphicon glyphicon-ok"></span>
			</button>
		</div>

	</xsl:template>

</xsl:stylesheet>
