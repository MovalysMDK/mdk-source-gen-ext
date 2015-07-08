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

	<xsl:template match="page[in-workspace='true' and count(menus/menu)>0]" mode="onCreate-method">
	
		/**
		 * {@inheritDoc}
		 */
		@Override
		public void onCreate(Bundle savedInstanceState) {
			super.onCreate(savedInstanceState);
			this.setHasOptionsMenu(true);
		}
	
	</xsl:template>
	
	<xsl:template match="*" mode="onCreate-method">

	</xsl:template>

	<xsl:template match="page" mode="fragmentOptionsMenu">
		
		<xsl:if test="in-workspace='true' and count(menus/menu)>0">
			/**
			 * (non-Javadoc)
			 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity#getOptionMenuIds()
			 */
			@Override
			public void onCreateOptionsMenu(Menu p_oMenu, MenuInflater p_oInflater) {
				super.onCreateOptionsMenu(p_oMenu, p_oInflater);
				<xsl:call-template name="non-generated-bloc">
					<xsl:with-param name="blocId">onCreateOptionsMenu</xsl:with-param>
					<xsl:with-param name="defaultSource">
						<xsl:apply-templates select="menus/menu" mode="inflate-option-menu"/>
					</xsl:with-param>
				</xsl:call-template>
			}
			
			<xsl:apply-templates select="menus/menu/menu-item" mode="pageOptionsMenuItem"/>
			
		</xsl:if>
		
	</xsl:template>

	<xsl:template match="*" mode="inflate-option-menu">
		
		<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		
		<xsl:variable name="screen" select="../../screen-class"/>
		<xsl:variable name="screenlower" select="translate($screen, $uppercase, $smallcase)">
			<!-- <xsl:call-template name="string-replace-all">
				<xsl:with-param name="text" select="$screen" />
				<xsl:with-param name="replace" select="$uppercase" />
				<xsl:with-param name="by" select="$smallcase" />
			</xsl:call-template> -->
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="/page/parameters/parameter[@name='workspace-panel-type']='master'">
				<xsl:text>p_oInflater.inflate(R.menu.</xsl:text><xsl:value-of select="$screenlower"/>
				<xsl:text>_list_actions, p_oMenu);</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="menu-item">
					<xsl:text>if (p_oMenu.findItem(R.id.actionmenu_</xsl:text><xsl:value-of select="$screenlower"/>
					<xsl:if test="action-provider/type='SAVEDETAIL'"> 
						<xsl:text>_save</xsl:text>
					</xsl:if>
					<xsl:if test="action-provider/type='DELETEDETAIL'"> 
						<xsl:text>_delete</xsl:text>
					</xsl:if>
					<xsl:text>) == null) {</xsl:text>
					<xsl:text>p_oInflater.inflate(R.menu.</xsl:text><xsl:value-of select="$screenlower"/>
					<xsl:text>_detail_actions, p_oMenu);
								}
					</xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>

	<xsl:template match="menu-item" mode="pageOptionsMenuItem">
		<xsl:apply-templates select="button/navigation" mode="optionPageNavigation"/>
	</xsl:template>

	<xsl:template match="navigation" mode="optionPageNavigation">
	
		<xsl:choose>
			<xsl:when test="@type='NAVIGATION_WKS_SWITCHPANEL' and target/name and ../../@id">
			/**
			 * Listener du menu contextuel d'id <xsl:value-of select="../../@id"/> 
			 */
			@ListenerOnMenuItemClick(R.id.<xsl:value-of select="../../@id"/>)
			public void launch<xsl:value-of select="target/name"/>() {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">onMenuItem<xsl:value-of select="target/name"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:text>((AbstractWorkspaceMasterDetailMMFragmentActivity) this.getActivity()).getWadapter().resetSelectedItem();&#13;</xsl:text>
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
