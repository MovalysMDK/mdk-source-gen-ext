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

	<xsl:if test="count(./*[self::menus/menu | self::options-menu]) >= 1">

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
			<xsl:if test="workspace='false'">
				<xsl:if test="count(./*[self::menus/menu[@id='option']]) >= 1">
					<xsl:apply-templates select="menus/menu[@id='option']/menu-item[1]" mode="activityOptionsMenu-Add"/>
				</xsl:if>
				<xsl:if test="count(./*[self::menus/menu[@id='actions']]) >= 1">
					<xsl:apply-templates select="menus/menu[@id='actions']" mode="activityOptionsMenu-Add"/>
				</xsl:if>
			</xsl:if>
			
			return r_listMenuIds;
			</xsl:with-param>
		</xsl:call-template>
		}
		
		<xsl:apply-templates select="options-menu/menu-item | menus/menu[@id='actions']/menu-item | menus/menu[@id='options']/menu-item" mode="activityOptionsMenuItem"/>
		
	</xsl:if>
	
</xsl:template>

<xsl:template match="menu[@id='actions']" mode="activityOptionsMenu-Add">
	
	<xsl:if test="count(child::*) > 0">
		r_listMenuIds.add(0, R.menu.<xsl:value-of select="../../name-lowercase"/>_actions);
	</xsl:if>
	
</xsl:template>

<xsl:template match="options-menu" mode="activityOptionsMenu-Add">

	<xsl:if test="count(child::*) > 0">
		r_listMenuIds.add(0, R.menu.<xsl:value-of select="@id"/>);
	</xsl:if>
	
</xsl:template>

<xsl:template match="menu-item" mode="activityOptionsMenu-Add">
		r_listMenuIds.add(0, R.menu.<xsl:value-of select="navigation/source/name-lowercase"/>_option);
</xsl:template>

<xsl:template match="*" mode="activityOptionsMenu-Add"/>

<xsl:template match="options-menu/menu-item " mode="activityOptionsMenuItem"/>


<xsl:template match="menu/menu-item" mode="activityOptionsMenuItem">
	
	<xsl:variable name="suffix">
		<xsl:choose>
			<xsl:when test="../@id='actions'">Action</xsl:when>
			<xsl:when test="../@id='options'">Option</xsl:when>
		</xsl:choose>
	</xsl:variable>
		
	<xsl:apply-templates select="navigation | button/navigation" mode="optionNavigation">
		<xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
	
	<xsl:apply-templates select="." mode="optionAction">
		<xsl:with-param name="suffix" select="$suffix"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="navigation" mode="optionNavigation">
	<xsl:param name="suffix"/>

	<xsl:choose>
		<!-- case options menu -->
		<xsl:when test="target/name and ../@id">
			/**
			 * Listener du menu contextuel d'id <xsl:value-of select="../@id"/> 
			 */
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="../@id"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../@id"/>)
				</xsl:with-param>
			</xsl:call-template>
			public void launch<xsl:value-of select="target/name"/><xsl:value-of select="$suffix"/>() {
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
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="../../@id"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../../@id"/>)
				</xsl:with-param>
			</xsl:call-template>
			public void launch<xsl:value-of select="target/name"/><xsl:value-of select="$suffix"/>() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="target/name"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:apply-templates select="."/>
				</xsl:with-param>
			</xsl:call-template>
			}
		</xsl:when>
		<xsl:when test="source/name and ../../@id">
			<xsl:variable name="methodMiddleName">
				<xsl:value-of select="source/name"/>
				<xsl:text></xsl:text>
				<xsl:choose>
				<xsl:when test="@type='NAVIGATION_INFO'">Info</xsl:when>
				</xsl:choose>
			</xsl:variable>
	
			/**
			 * Listener du menu contextuel d'id <xsl:value-of select="../../@id"/> 
			 */
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="../../@id"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../../@id"/>)
				</xsl:with-param>
			</xsl:call-template>
			public void launch<xsl:value-of select="$methodMiddleName"/><xsl:value-of select="$suffix"/>() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="$methodMiddleName"/><xsl:value-of select="$suffix"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
			        FragmentManager oFragmentManager = this.getSupportFragmentManager();
					if (oFragmentManager != null) {
						WebViewDialog oWebViewDialog = WebViewDialog.newInstance("Info for <xsl:value-of select="source/name"/>", "file:///android_asset/<xsl:value-of select="source/name"/>.html", "Cancel");
						oWebViewDialog.show(oFragmentManager, "<xsl:value-of select="source/name"/>");	
					}
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

<xsl:template match="*" mode="optionAction">
	<xsl:param name="suffix"/>
	
	<xsl:variable name="methodMiddleName">
		<xsl:value-of select="method-name"/>
		<xsl:choose>
			<xsl:when test="action-provider/type='SAVEDETAIL'">Save</xsl:when>
			<xsl:when test="action-provider/type='DELETEDETAIL'">Delete</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:if test="count(./actions/action) >= 1">
		/**
		 * Listener du menu contextuel d'id <xsl:value-of select="@id"/> 
		 */
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="@id"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				@ListenerOnMenuItemClick(R.id.<xsl:value-of select="@id"/>)
			</xsl:with-param>
		</xsl:call-template>
		public void launch<xsl:value-of select="$methodMiddleName"/><xsl:value-of select="$suffix"/>() {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="$methodMiddleName"/><xsl:value-of select="$suffix"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:apply-templates select="." mode="menu-launch-action"/>
			</xsl:with-param>
		</xsl:call-template>
		}
	</xsl:if>
</xsl:template>

<xsl:template match="*" mode="menu-launch-action">
	
	<!-- case with on action -->
	<xsl:if test="count(actions/action) = 1">
		<xsl:text>this.launchAction(</xsl:text>
		<xsl:value-of select="actions/action/implements/interface/@name" />
		<xsl:text>.class, new NullActionParameterImpl());&#13;</xsl:text>
	</xsl:if>
	
	<!-- case with multiple actions -->
	<xsl:if test="count(actions/action) > 1">
	
		<xsl:text>NullActionParameterImpl oParameterIn = new NullActionParameterImpl();
		oParameterIn.setRuleParameters(this.getParameters());</xsl:text>
		
		<xsl:choose>
			<xsl:when test="actions/action[1]/action-type = 'DELETEDETAIL'">
				<xsl:text>ChainDeleteActionDetailParameter oChainParameter = new ChainDeleteActionDetailParameter(oParameterIn, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>ChainSaveActionDetailParameter oChainParameter = new ChainSaveActionDetailParameter(oParameterIn, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:for-each select="actions/action">
			<xsl:value-of select="implements/interface/@name" />
			<xsl:text>.class </xsl:text> 
			<xsl:if test="position() != last()">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		
		<xsl:text>);</xsl:text>
			
		<xsl:choose>
			<xsl:when test="actions/action[1]/action-type = 'DELETEDETAIL'">
				<xsl:text>this.launchAction(ChainDeleteDetailAction.class, oChainParameter);&#13;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>this.launchAction(ChainSaveDetailAction.class, oChainParameter);&#13;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:if>

</xsl:template>

</xsl:stylesheet>
