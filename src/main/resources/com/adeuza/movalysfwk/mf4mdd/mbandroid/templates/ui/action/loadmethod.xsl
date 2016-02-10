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

	<!-- TEMPLATES DE GÉNÉRATION DE LA MÉTHODE DE CHARGEMENT EN FONCTION DU TYPE DE L'ACTION -->

	<!--  Display SIMPLE -->	
	<xsl:template match="action[action-type='DISPLAYSIMPLE']" mode="generate-load-method">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected String loadData(MContext p_oContext, NullActionParameterImpl p_oInParameter) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-load-data</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:text>return null;&#13;</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
		}
	</xsl:template>


	<!--  Display DETAIL -->
	<xsl:template match="action[action-type='DISPLAYDETAIL']" mode="generate-load-method">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected void loadData(MContext p_oContext,InDisplayParameter p_oInParameter) {
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-load-data</xsl:with-param>
			<xsl:with-param name="defaultSource">
		<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-declaration"/>
			try  {
				<xsl:value-of select="./dao-interface/name"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="./dao-interface/name"/>.class);
				ViewModelCreator oCreator = (ViewModelCreator)Application.getInstance().getViewModelCreator();
				<xsl:value-of select="./class/implements/interface/@name"/> o<xsl:value-of select="./class/implements/interface/@name"/>
				<xsl:text> = oDao.get</xsl:text><xsl:value-of select="./class/implements/interface/@name"/>(
						Long.parseLong(p_oInParameter.getId()), 
						CascadeSet.of(<xsl:for-each select="./viewmodel/cascades/cascade"><xsl:if test="position()!=1">,</xsl:if><xsl:value-of select="."/></xsl:for-each>),
						p_oContext) ; 
				
			<xsl:value-of select="./viewmodel/implements/interface/@name"/>
			<xsl:text> oVm = oCreator.create</xsl:text>
			<xsl:value-of select="./viewmodel/implements/interface/@name"/>
			<xsl:text>( o</xsl:text><xsl:value-of select="./class/implements/interface/@name"/>
			<xsl:apply-templates select="external-daos/dao-interface" mode="generate-dao-getX"/>);
	
				oVm.setEditable(this.isViewModelEnabled(oVm));
			}
			catch(DaoException oException) {
				Log.e(this.getClass().getSimpleName(), "Erreur in loadData", oException);
				p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
			}	
			</xsl:with-param>
		</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="action[action-type='DISPLAYWORKSPACE']" mode="generate-load-method">
		<xsl:variable name="vmName"><xsl:value-of select="./parameters/parameter[@name='vmworkspace']"/></xsl:variable>
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected String loadData(MContext p_oContext,NullActionParameterImpl p_oInParameter) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-load-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
				//MF_DEV_MANDATORY Change select ...
				try  {
					<xsl:value-of select="./dao-interface/name"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="./dao-interface/name"/>.class);
					ViewModelCreator oCreator = (ViewModelCreator)Application.getInstance().getViewModelCreator();
					<xsl:value-of select="$vmName"/> oVm = oCreator.create<xsl:value-of select="$vmName"/>(
						oDao.getList<xsl:value-of select="./class/implements/interface/@name"/>(
							CascadeSet.of(<xsl:for-each select="./viewmodel/subvm/viewmodel/cascades/cascade">
								<xsl:if test="position()!=1">,</xsl:if>
								<xsl:value-of select="."/></xsl:for-each>),
							p_oContext));
	
					oVm.setEditable(this.isViewModelEnabled(oVm));
				}
				catch(DaoException oException) {
					Log.e(this.getClass().getSimpleName(), "Erreur in loadData", oException);
					p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
				}	
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>return null;&#13;</xsl:text>
		}
	</xsl:template>

	<!--  Display LIST -->
	<xsl:template match="action[action-type='DISPLAYLIST']" mode="generate-load-method">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected String loadData(MContext p_oContext,NullActionParameterImpl p_oInParameter) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-load-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
				try  {
					<xsl:if test="not(search-dialog)">
					//MF_DEV_MANDATORY Change select ...
					</xsl:if>
					<xsl:apply-templates select="search-dialog" mode="generate-viewmodel-creation"/>
					<xsl:variable name="resultVarName">list<xsl:value-of select="./class/implements/interface/@name"/></xsl:variable>
					
					<xsl:value-of select="./dao-interface/name"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="./dao-interface/name"/>.class);
					List&lt;<xsl:value-of select="./class/implements/interface/@name"/><xsl:text>&gt; </xsl:text>
							<xsl:value-of select="$resultVarName"/>
							<xsl:text> = oDao.getList</xsl:text><xsl:value-of select="./class/implements/interface/@name"/>(
							CascadeSet.of(<xsl:for-each select="./viewmodel/subvm/viewmodel/cascades/cascade">
								<xsl:if test="position()!=1">,</xsl:if>
								<xsl:value-of select="."/></xsl:for-each>), p_oContext );
				
					ViewModelCreator oCreator = (ViewModelCreator)Application.getInstance().getViewModelCreator();
					<xsl:value-of select="./viewmodel/implements/interface/@name"/>
					<xsl:text> oVm = oCreator.create</xsl:text><xsl:value-of select="./viewmodel/implements/interface/@name"/>
					<xsl:text>(</xsl:text><xsl:value-of select="$resultVarName"/>);
	
					oVm.setEditable(this.isViewModelEnabled(oVm));
				}
				catch(DaoException oException) {
					Log.e(this.getClass().getSimpleName(), "Erreur in loadData", oException);
					p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
				}	
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>return null;&#13;</xsl:text>
		}
	</xsl:template>

	<!--  Display -->
	<xsl:template match="action[action-type='DISPLAY' or action-type='DIALOG']" mode="generate-load-method">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected String loadData(MContext p_oContext,NullActionParameterImpl p_oInParameter) {
			String r_sId = null;
			ViewModelCreator oCreator = (ViewModelCreator) Application.getInstance().getViewModelCreator();
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-load-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
					//MF_DEV_MANDATORY Change select ...
					<xsl:apply-templates select="." mode="generate-viewmodel-creation"/>
				</xsl:with-param>
			</xsl:call-template>
			return r_sId;
		}
	</xsl:template>
	
	
	
	<!-- Get the object holding the search criterias for use with dao -->
	<xsl:template match="search-dialog[class/transient='true']" mode="generate-viewmodel-creation">
		<xsl:variable name="varName">o<xsl:value-of select="class/implements/interface/@name"/></xsl:variable>
		//MF_DEV_MANDATORY Change select using search criterias in <xsl:value-of select="$varName"/>...
		<xsl:value-of select="class/implements/interface/@name"/><xsl:text> </xsl:text>
		<xsl:value-of select="$varName"/> = Application.getInstance().getTranscientObjectFromCache("", <xsl:value-of select="class/implements/interface/@name"/>.class);
		if ( <xsl:value-of select="$varName"/> == null) {
			<xsl:value-of select="$varName"/> = BeanLoader.getInstance().getBean(<xsl:value-of select="class/pojo-factory-interface/name"/>.class).createInstance();
			Application.getInstance().addTranscientObjectToCache("", <xsl:value-of select="class/implements/interface/@name"/>.class, <xsl:value-of select="$varName"/>);
		}
	</xsl:template>
	
	<xsl:template match="search-dialog[class/transient='false']" mode="generate-viewmodel-creation">
		//TODO: viewmodelcreation.xsl searchdialog mode=generate-viewmodel-creation non-trancient-entity 
	</xsl:template>
	
</xsl:stylesheet>