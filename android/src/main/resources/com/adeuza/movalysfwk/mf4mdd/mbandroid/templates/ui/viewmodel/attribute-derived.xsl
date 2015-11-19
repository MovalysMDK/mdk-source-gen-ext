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

	<xsl:output method="text"/>

	<xsl:template match="attribute" mode="derived-method">

		<xsl:variable name="method-bloc-id"><xsl:value-of select="@name"/><xsl:text>-calc-method</xsl:text></xsl:variable>

			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId" select="$method-bloc-id"/>
				<xsl:with-param name="defaultSource">
					<!-- si il y a plusieurs champs, generer une method de calcul -->
					<xsl:text>/**&#13;</xsl:text>
					<xsl:text> * Listener method on the fields in parameter&#13;</xsl:text>
					<xsl:text> * @param p_sChamp modified field triggering the method&#13;</xsl:text>
					<xsl:text> * @param p_oOldVal old value of the field&#13;</xsl:text>
					<xsl:text> * @param p_oNewVal new value of the field&#13;</xsl:text>
					<xsl:text> */&#13;</xsl:text>
					<xsl:text>@ListenerOnFieldModified(fields={</xsl:text>
					<!-- toutes les clés des champs non derivé -->
					<xsl:for-each select="../attribute[@derived='false']">
						<xsl:text>KEY_</xsl:text><xsl:value-of select="@name-uppercase"/>
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>})&#13;</xsl:text>
					<xsl:text>public void </xsl:text><xsl:value-of select="@name"/><xsl:text>Operation(String p_sChamp, Object p_oOldVal, Object p_oNewVal) {</xsl:text>
					<xsl:text>
					// MF_DEV_MANDATORY
					// TODO auto-generated method
					</xsl:text>
					<xsl:value-of select="set-accessor"/><xsl:text>(null);</xsl:text>
					<xsl:text>}&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>

	</xsl:template>

	<xsl:template match="*" mode="derived-method">
	</xsl:template>

</xsl:stylesheet>