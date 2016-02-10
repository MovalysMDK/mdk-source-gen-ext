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

	<!-- ##########################################################################################
			Méthodes spécifiques aux écrans qui reposent sur un viewmodel de type liste.
		########################################################################################## -->


	<!-- *****************************************************************************************
											METHODES
		***************************************************************************************** -->

	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="extra-methods-imports">
		<xsl:apply-templates select="navigations/navigation[@name = 'navigationdetail']" mode="doOnSelectedItemEvent-import">
			<xsl:with-param name="adapter" select="adapter/full-name"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="extra-methods">
		<xsl:apply-templates select="navigations/navigation[@name = 'navigationdetail']" mode="doOnSelectedItemEvent-method">
			<xsl:with-param name="adapter" select="adapter/name"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- *****************************************************************************************
									doOnSelectedItemEvent
						Affichage du détail associé à un élément d'une liste.
		***************************************************************************************** -->

	<xsl:template match="navigation[@name = 'navigationdetail']" mode="doOnSelectedItemEvent-import">
		<xsl:param name="adapter"/>
		<import>android.content.Intent</import>
		<import>com.adeuza.movalysfwk.mobile.mf4javacommons.event.listener.ListenerOnBusinessNotification</import>
		<import><xsl:value-of select="$adapter"/></import>
		<import><xsl:value-of select="target/full-name"/></import>
	</xsl:template>

	<xsl:template match="navigation[@name = 'navigationdetail']" mode="doOnSelectedItemEvent-method">
		<xsl:param name="adapter"/>
		/**
		 * Callback from adapter event.
		 * @param p_oEvent the event 
		 */
		@ListenerOnBusinessNotification(<xsl:value-of select="$adapter"/>.SelectedItemEvent.class)
		public void doOnSelectedItemEvent(<xsl:value-of select="$adapter"/>.SelectedItemEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">OnSelectedItemEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
				if (p_oEvent.getSource() == this.adapter) {
					final Intent oIntent = new Intent(this, <xsl:value-of select="target/name"/>.class);
					oIntent.putExtra("id", p_oEvent.getData());
					oIntent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
					this.startActivityForResult(oIntent, <xsl:value-of select="target/name"/>.REQUEST_CODE);
				}
				</xsl:with-param>
			</xsl:call-template>
		}
		
		/**
		 * {@inheritDoc}
		 */
		@ListenerOnBusinessNotification(<xsl:value-of select="$adapter"/>.PerformItemClickEvent.class)
		public void doOnPerformItemClickEvent(final <xsl:value-of select="$adapter"/>.PerformItemClickEvent p_oEvent) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">OnPerformItemClickEvent</xsl:with-param>
				<xsl:with-param name="defaultSource">
					p_oEvent.getData().performItemClick();
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
</xsl:stylesheet>
