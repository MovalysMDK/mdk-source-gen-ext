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

<xsl:template match="screen" mode="activityOptionsMenu">
	
	<xsl:if test="count(./*[self::menus/menu | self::options-menu]) >=  1">

		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity#getOptionMenuIds()
		 */
		@Override
		public List&lt;Integer&gt; getOptionMenuIds() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-option-menu</xsl:with-param>
			<xsl:with-param name="defaultSource">
			List&lt;Integer&gt; r_listMenuIds = super.getOptionMenuIds();
			<xsl:for-each select="options-menu">
				<xsl:apply-templates select="." mode="activityOptionsMenu-Add"/>
			</xsl:for-each>
			<xsl:for-each select="menus/menu">
				<xsl:apply-templates select="." mode="activityOptionsMenu-Add"/>
			</xsl:for-each>
			return r_listMenuIds;
			</xsl:with-param>
		</xsl:call-template>
		}
		
		<xsl:apply-templates select="options-menu/menu-item | menus/menu[@id='actions']/menu-item" mode="activityOptionsMenuItem"/>
		
	</xsl:if>
	
</xsl:template>

<xsl:template match="menu[@id='actions']" mode="activityOptionsMenu-Add">
	
	r_listMenuIds.add(0, R.menu.<xsl:value-of select="../../name-lowercase"/>_actions);
	
</xsl:template>

<xsl:template match="options-menu" mode="activityOptionsMenu-Add">

	r_listMenuIds.add(0, R.menu.<xsl:value-of select="@id"/>);
	
</xsl:template>

<xsl:template match="*" mode="activityOptionsMenu-Add"/>

<xsl:template match="menu-item" mode="activityOptionsMenuItem">
	<xsl:apply-templates select="navigation | button/navigation" mode="optionNavigation"/>
</xsl:template>

<xsl:template match="navigation" mode="optionNavigation">

	<xsl:choose>
	  <!-- case options menu -->
	  <xsl:when test="target/name and ../@id">
	    /**
		 * Listener du menu contextuel d'id <xsl:value-of select="../@id"/> 
		 */
		@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../@id"/>)
		public void launch<xsl:value-of select="target/name"/>() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="target/name"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="."/>
			</xsl:with-param>
		</xsl:call-template>
		}
	  </xsl:when>
	  <!-- case actions menu -->
	  <xsl:when test="target/name and ../../@id">
	    /**
		 * Listener du menu contextuel d'id <xsl:value-of select="../../@id"/> 
		 */
		@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../../@id"/>)
		public void launch<xsl:value-of select="target/name"/>() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="target/name"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="."/>
			</xsl:with-param>
		</xsl:call-template>
		}
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

<xsl:template match="*" mode="optionNavigation">
</xsl:template>

</xsl:stylesheet>
