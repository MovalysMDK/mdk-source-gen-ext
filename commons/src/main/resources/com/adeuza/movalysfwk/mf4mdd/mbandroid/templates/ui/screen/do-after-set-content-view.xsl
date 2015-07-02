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
	<xsl:output method="text" />

	<xsl:template match="screen" mode="doAfterSetContentView-method">
		/**
		 * {@inheritDoc}
		 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.AbstractMMActivity#doAfterSetContentView()
		 */
		@Override
		protected void doAfterSetContentView() {
			super.doAfterSetContentView();
			
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">do-after-set-content-view-1</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>

			<xsl:apply-templates select="pages/page[@pos='1']/adapter" mode="doAfterSetContentView-method"/>
			<xsl:apply-templates select="pages/page/external-adapters/adapter" mode="doAfterSetContentView-method"/>

			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">do-after-set-content-view-2</xsl:with-param>
				<xsl:with-param name="defaultSource">
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="pages/page/adapter[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="doAfterSetContentView-method">
		this.adapter = new <xsl:value-of select="name"/>(<xsl:apply-templates select=".." mode="get-page-vm"/>);
		this.associateAdapterComponent = (
		<xsl:choose>
			<xsl:when test="../mastercomponenttype = 'MMListView' or ../mastercomponenttype = 'MMExpandableListView'">
				<xsl:text>MMAdaptableListView</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="../mastercomponenttype"/>
			</xsl:otherwise> 
		</xsl:choose>
		) this.findViewById(R.id.<xsl:value-of select="../mastercomponentname"/>);
		this.associateAdapterComponent.setListAdapter(this.adapter);
	</xsl:template>

	<!-- ##########################################################################################
											SPINNER
		########################################################################################## -->

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="doAfterSetContentView-method">
		<xsl:param name="viewGroup">this</xsl:param>
		<xsl:if test="not(ancestor::screen/workspace = 'true')">
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">set-spinner-adapter<xsl:value-of select="position()"/></xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:variable name="vm-name" select="viewmodel/implements/interface/@full-name"/>
					<xsl:if test="not(../adapter/viewmodel/external-lists/external-list/viewmodel[implements/interface/@full-name=$vm-name])">
						this.spinner<xsl:value-of select="position()"/><xsl:text> = (</xsl:text>
						<xsl:apply-templates select="viewmodel" mode="doAfterSetContentView-method"/>
						<xsl:text>) </xsl:text><xsl:value-of select="$viewGroup"/>
						<xsl:text>.findViewById(R.id.</xsl:text><xsl:value-of select="@component-ref"/>);
						if (this.spinner<xsl:value-of select="position()"/><xsl:text> != null) {&#13;</xsl:text>
						this.spinnerAdapter<xsl:value-of select="position()"/> = new <xsl:value-of select="name"/>
						<xsl:if test="name='ConfigurableSpinnerAdapter' or name='MDKSpinnerAdapter'">
							<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
							<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
							<xsl:text>, ListViewModel</xsl:text>
							<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
							<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
							<xsl:text>&gt;&gt;</xsl:text>
						</xsl:if>
						<xsl:text>(</xsl:text>
						<xsl:apply-templates select="." mode="constructor-parameters">
							<xsl:with-param name="position" select="position()"/>
						</xsl:apply-templates>
						<xsl:text>, true );</xsl:text>
						this.spinner<xsl:value-of select="position()"/>.setAdapter(this.spinnerAdapter<xsl:value-of select="position()"/>);
						}
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="external-adapters/adapter/viewmodel[type/name='LIST_1__ONE_SELECTED']" mode="doAfterSetContentView-method">
		<xsl:text>MMSpinnerAdapterHolder&lt;?,?&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="external-adapters/adapter/viewmodel[type/name='LIST_1__ONE_SELECTED' and type/conf-name='filter']" mode="doAfterSetContentView-method">
		<xsl:text>MMSpinnerAdapterHolder&lt;?,?&gt;</xsl:text>
	</xsl:template>

	<!-- ##########################################################################################
											FIXED_LIST
		########################################################################################## -->

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='FIXED_LIST']" mode="doAfterSetContentView-method">
		<xsl:variable name="adapter-name">
			<xsl:text>fixedListAdapter</xsl:text>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:variable name="component-name">
			<xsl:text>fixedList</xsl:text>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:variable name="vm" select="../../viewmodel-interface/name"/>

		this.<xsl:value-of select="$component-name"/>
		<xsl:text> = (</xsl:text>
		<xsl:text>MMAdaptableFixedListView&lt;</xsl:text>
		<xsl:value-of select="viewmodel/entity-to-update/name"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>&gt;) this.findViewById(R.id.</xsl:text>
		<xsl:value-of select="@component-ref"/>
		<xsl:text>);&#13;</xsl:text>

		<xsl:text>if (this.</xsl:text>
		<xsl:value-of select="$component-name"/>
		<xsl:text> != null) {&#13;</xsl:text>

		<xsl:text>this.</xsl:text>
		<xsl:value-of select="$adapter-name"/>
		<xsl:text> = new </xsl:text>
		<xsl:value-of select="name"/>
		<xsl:text>(</xsl:text>
		<xsl:apply-templates select="." mode="constructor-parameters">
			<xsl:with-param name="position" select="position()"/>
		</xsl:apply-templates>
		<xsl:text>);&#13;</xsl:text>

		<xsl:apply-templates select="viewmodel//external-lists/external-list/viewmodel" mode="add-reference-to">
			<xsl:with-param name="fixedAdapterName" select="$adapter-name"/>
		</xsl:apply-templates>

		<xsl:text>this.</xsl:text>
		<xsl:value-of select="$component-name"/>
		<xsl:text>.setAdapter(this.fixedListAdapter</xsl:text>
		<xsl:value-of select="position()"/>
		<xsl:text>);&#13;}&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="external-list/viewmodel" mode="add-reference-to">
		<xsl:param name="fixedAdapterName"/>
		<xsl:variable name="vm-name" select="implements/interface/@full-name"/>
		<xsl:apply-templates select="ancestor::page/external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED' and viewmodel/implements/interface/@full-name=$vm-name]" mode="add-reference-to">
			<xsl:with-param name="fixedAdapterName" select="$fixedAdapterName"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="external-adapters/adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="add-reference-to">
		<xsl:param name="fixedAdapterName"/>
		<xsl:variable name="adapter-pos" select="count(preceding::adapter[parent::external-adapters]) + 1"/>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">set-spinner-adapter<xsl:value-of select="$adapter-pos"/></xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>	this.spinnerAdapter</xsl:text>
				<xsl:value-of select="$adapter-pos"/>
				<xsl:text> = new </xsl:text>
				<xsl:value-of select="name"/>
				<xsl:if test="name='ConfigurableSpinnerAdapter' or name='MDKSpinnerAdapter'">
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>, ListViewModel</xsl:text>
					<xsl:text>&lt;</xsl:text><xsl:value-of select="viewmodel/entity-to-update/name"/>
					<xsl:text>, </xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
					<xsl:text>&gt;&gt;</xsl:text>
				</xsl:if>
				<xsl:text>(</xsl:text>
				<xsl:apply-templates select="." mode="constructor-parameters">
					<xsl:with-param name="position" select="$adapter-pos"/>
				</xsl:apply-templates>
				<xsl:text>, true);&#13;this.</xsl:text>
				<xsl:value-of select="$fixedAdapterName"/>
				<xsl:text>.addReferenceTo(R.id.sel</xsl:text>
				<xsl:value-of select="@component-ref"/>
				<xsl:text>, this.spinnerAdapter</xsl:text>
				<xsl:value-of select="$adapter-pos"/>
				<xsl:text>);&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- ##########################################################################################
							PARAMETRES FOURNIS A L'INITIALISATION DES ADAPTERS
		########################################################################################## -->

	<xsl:template match="adapter[viewmodel/type/name='LIST_1__ONE_SELECTED']" mode="constructor-parameters">
		<xsl:apply-templates select="ancestor::*[local-name()='page' or local-name()='dialog'][1]" mode="get-page-vm"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="viewmodel/list-accessor-get-name"/>
		<xsl:text>()</xsl:text>
		<xsl:text>, </xsl:text>
		<xsl:apply-templates select="." mode="generate-super-constructor-parameters"/>
	</xsl:template>

	<xsl:template match="adapter[viewmodel/type/name='FIXED_LIST']" mode="constructor-parameters"/>


	<!-- ##########################################################################################
											RECUPERATION D'UN VM
		########################################################################################## -->

	<xsl:template match="screen[workspace='false']/pages/page" mode="get-page-vm">
		<xsl:text>((</xsl:text><xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>) this.getViewModel())</xsl:text>
	</xsl:template>
	
	<xsl:template match="screen[workspace='true']/pages/page" mode="get-page-vm">
		<xsl:text>((</xsl:text>
		<xsl:value-of select="../../viewmodel/implements/interface/@name"/>
		<xsl:text>) this.getViewModel()).</xsl:text>
		<xsl:value-of select="viewmodel/accessor-get-name"/>
		<xsl:text>()</xsl:text>
	</xsl:template>

	<xsl:template match="screen[workspace='true']/pages/page[viewmodel/type[name='LIST_1' or name='LIST_2' or name='LIST_3']]" mode="get-page-vm">
		<xsl:text>((</xsl:text>
		<xsl:value-of select="../../viewmodel/implements/interface/@name"/>
		<xsl:text>) this.getViewModel()).get</xsl:text>
		<xsl:value-of select="viewmodel/implements/interface/@name"/>
		<xsl:text>()</xsl:text>
	</xsl:template>

</xsl:stylesheet>
