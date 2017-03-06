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
	
	<!-- TEMPLATES DE GÉNÉRATION DE LA MÉTHODE EN FONCTION DU TYPE DE L'ACTION -->

	<xsl:template match="action[action-type='SAVEDETAIL']" mode="generate-methods">

	<xsl:variable name="classinterfacename"><xsl:value-of select="./class/implements/interface/@name"/></xsl:variable>
	<xsl:variable name="daointerfacename"><xsl:value-of select="./dao-interface/name"/></xsl:variable>
	<xsl:variable name="varResult">r_o<xsl:value-of select="$classinterfacename"/>ToSave</xsl:variable>	
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.SaveDetailAction#validateData(com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl,com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext)
	 */
	@Override
	public boolean validateData(NullActionParameterImpl p_oParameterIn, MContext p_oContext) throws ActionException {
		
		<xsl:apply-templates select="./viewmodel" mode="generate-view-model-creation">
			<xsl:with-param name="linked-object"><xsl:value-of select="$varResult "/></xsl:with-param>
			<xsl:with-param name="panel-name-suffix">Main</xsl:with-param>
		</xsl:apply-templates>

		// validComponents retourne true if une erreur est détectée.
		boolean r_bValid = !oVMLinkedPanelMain.validComponents(p_oContext, p_oParameterIn == null ? null : p_oParameterIn.getRuleParameters());
		if (r_bValid) {
			int iErrorsNumber = p_oContext.getNumberOfMessagesByLevel(MessageLevel.ERROR);
			r_bValid = oVMLinkedPanelMain.validViewModel(p_oContext, p_oParameterIn == null ? null : p_oParameterIn.getRuleParameters());
			r_bValid = oVMLinkedPanelMain.validateUserErrors(p_oContext) &amp;&amp; r_bValid;
			
			// si une erreur est détectée et qu'aucun message d'erreur n'a été ajouté au contexte, ajout du message par défaut.
			if (iErrorsNumber == p_oContext.getNumberOfMessagesByLevel(MessageLevel.ERROR) &amp;&amp; !r_bValid) {
				p_oContext.getMessages().addMessage(ExtFwkErrors.InvalidViewModelDataError);
			}
		} else {
			// Des problèmes existent dans les composants, on n'évalue donc pas la validité du viewmodel car cela pourrait être source d'erreurs
			p_oContext.getMessages().addMessage(ExtFwkErrors.InvalidViewModelDataError);
		}
		
		return r_bValid;
	}
	
	
	/**
	 * {@inheritDoc}
	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.AbstractSaveDetailActionImpl#saveData(com.adeuza.movalysfwk.mf4jcommons.core.beans.MEntity, com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl, com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext)
	 */
	@Override
	public <xsl:value-of select="$classinterfacename"/> saveData( <xsl:value-of select="$classinterfacename"/> p_o<xsl:value-of select="$classinterfacename"/>
		<xsl:text>, NullActionParameterImpl p_oInParameter, MContext p_oContext) throws ActionException {&#13;</xsl:text>
				
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-save-data</xsl:with-param>
			<xsl:with-param name="defaultSource">
				<xsl:value-of select="$classinterfacename"/> r_o<xsl:value-of select="$classinterfacename"/> = p_o<xsl:value-of select="$classinterfacename"/>;
				<xsl:if test="class/transient = 'false'">
				try  {
					<xsl:value-of select="$daointerfacename"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="$daointerfacename"/>.class);

					oDao.saveOrUpdate<xsl:value-of select="$classinterfacename"/>(p_o<xsl:value-of select="$classinterfacename"/>,
						CascadeSet.of(<xsl:for-each select="./viewmodel/savecascades/cascade">
							<xsl:if test="position()!=1">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:if test="viewmodel[customizable='true']">
							<xsl:if test="viewmodel/savecascades/cascade">
								<xsl:text>, </xsl:text>
							</xsl:if>
							<xsl:text>CascadeSet.GenericCascade.CUSTOM_FIELDS</xsl:text>
						</xsl:if>),
						p_oContext);
					
				} catch (DaoException oException) {
					throw new ActionException(oException);
				}
				</xsl:if>
				return r_o<xsl:value-of select="$classinterfacename"/>;
			</xsl:with-param>
		</xsl:call-template>
	}
	
		/**
	 	* {@inheritDoc}
	 	* @see com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.SaveDetailAction#preSaveData(com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl, com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext)
	 	*/
		@Override
		public <xsl:value-of select="$classinterfacename"/> preSaveData(NullActionParameterImpl p_oParameterIn,
				MContext p_oContext) throws ActionException {
				
			<xsl:value-of select="$classinterfacename"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$varResult"/>; 
			
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-presave-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
					// ancien objet avant modification 
					<xsl:value-of select="$varResult"/><xsl:text> = </xsl:text>
					<xsl:text>BeanLoader.getInstance().getBean(</xsl:text>
					<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>
					<xsl:text>.class).getData(</xsl:text>
					<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>
					<xsl:text>.DEFAULT_KEY)</xsl:text>
					<xsl:value-of select="viewmodel/data-path/full-path"/>
					<xsl:text>;</xsl:text>
					if ( <xsl:value-of select="$varResult"/> == null) {
						<xsl:value-of select="$varResult"/>
						<xsl:text> = BeanLoader.getInstance().getBean(</xsl:text>
						<xsl:value-of select="class/pojo-factory-interface/name"/>.class).createInstance();
						<xsl:apply-templates select="./viewmodel/dataloader-impl" mode="set-entity">
							<xsl:with-param name="varResult" select="$varResult"/>
						</xsl:apply-templates>
					}
					
					<xsl:apply-templates select="./viewmodel" mode="generate-view-model-creation">
						<xsl:with-param name="linked-object"><xsl:value-of select="$varResult "/></xsl:with-param>
						<xsl:with-param name="panel-name-suffix">Main</xsl:with-param>
					</xsl:apply-templates>
					
					oVMLinkedPanelMain.modifyToIdentifiable(<xsl:value-of select="$varResult"/>);
					
					this.modifyEntityBeforeSave(<xsl:value-of select="$varResult"/>); // for overloading
				</xsl:with-param>
			</xsl:call-template>
			
			return <xsl:value-of select="$varResult"/> ;
		}
		
		/**
	 	 * {@inheritDoc}
	 	 * @see com.adeuza.movalysfwk.mobile.mf4android.activity.business.genericsave.SaveDetailAction#postSaveData(com.adeuza.movalysfwk.mf4jcommons.core.beans.MEntity, com.adeuza.movalysfwk.mobile.mf4mjcommons.action.NullActionParameterImpl, com.adeuza.movalysfwk.mobile.mf4mjcommons.context.MContext)
	 	 */
		@Override
		public void postSaveData(<xsl:value-of select="$classinterfacename"/> p_o<xsl:value-of select="$classinterfacename"/>,
				NullActionParameterImpl p_oParameterIn, MContext p_oContext)
				throws ActionException {
				
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-postsave-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
				
					<xsl:apply-templates select="./viewmodel" mode="generate-view-model-creation">
						<xsl:with-param name="linked-object"><xsl:value-of select="$varResult "/></xsl:with-param>
						<xsl:with-param name="panel-name-suffix">Main</xsl:with-param>
					</xsl:apply-templates>
				
					<!-- xsl:if test="class/transient = 'true' and class/scope != 'APPLICATION'"-->
					<xsl:if test="events[event/@type='onadd']">
					long lVmId = oVMLinkedPanelMain.getId_<xsl:value-of select="class/identifier/attribute/@name"/>();
					long lEntityId = p_o<xsl:value-of select="$classinterfacename"/>.<xsl:value-of select="class/identifier/attribute/get-accessor"/>();
					boolean bCreation = !(lVmId == lEntityId);
					<xsl:if test="class/scope = 'APPLICATION'">
					boolean bCreation = false ;
					</xsl:if>
					<xsl:if test="class/transient = 'true' and class/scope != 'APPLICATION'">
					boolean bCreation = true ;
					</xsl:if>
					</xsl:if>
					<!-- /xsl:if-->

					oVMLinkedPanelMain.updateFromIdentifiable(p_o<xsl:value-of select="$classinterfacename"/>);
					<!--ABE oVMLinkedPanelMain.writeData(p_oContext, p_oParameterIn == null ? null : p_oParameterIn.getRuleParameters()); -->
					// TODO uncomment if view model are not syncronized anymore
					// oVMLinkedPanelMain.doOnDataLoaded(p_oParameterIn.getRuleParameters());
					
					<xsl:apply-templates select="events">
						<xsl:with-param name="varResult">p_o<xsl:value-of select="$classinterfacename"/></xsl:with-param>
					</xsl:apply-templates>
				</xsl:with-param>
			</xsl:call-template>
		}

		<xsl:apply-templates select="." mode="persistentsavedetail-methods"/>

	</xsl:template>
	
	<xsl:template match="action[action-type='SAVEDETAIL' and class/transient='false']" mode="persistentsavedetail-methods">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected Collection&lt;MObjectToSynchronize&gt; toSynchronize(MContext p_oContext, <xsl:value-of select="class/implements/interface/@name"/> p_oEntity) throws ActionException {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-to-synchronize</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:if test="count(class/identifier/attribute) = 1 and ( class/identifier/attribute/@type-name = 'long' or class/identifier/attribute/@type-short-name = 'Long' ) ">
						final Collection&lt;MObjectToSynchronize&gt; r_listObjectToSync = new ArrayList&lt;MObjectToSynchronize&gt;();
						MObjectToSynchronize oObject2Synchronize = BeanLoader.getInstance().getBean(MObjectToSynchronizeFactory.class).createInstance();
						r_listObjectToSync.add(oObject2Synchronize);
						oObject2Synchronize.setObjectId(p_oEntity.<xsl:value-of select="class/identifier/attribute/get-accessor"/>());
						oObject2Synchronize.setObjectName(<xsl:value-of select="class/implements/interface/@name"/>.class.getName());
						return r_listObjectToSync;
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		}
	</xsl:template>
	
	<xsl:template match="action[class/transient='true']" mode="persistentsavedetail-methods">
	</xsl:template>
	
	<xsl:template match="events[event/@type='onadd']">
		<xsl:param name="varResult"/>
		BusinessEvent&lt;<xsl:value-of select="../class/implements/interface/@name"/>&gt; oEvent = null;
		// si l'id du view modele a change on modifie le cache des view models
		if ( bCreation ) {
			oEvent = <xsl:apply-templates select="event[@type='onadd']"><xsl:with-param name="varResult" select="$varResult"/></xsl:apply-templates>;
		}
		else {
			oEvent = <xsl:apply-templates select="event[@type='onchange']"><xsl:with-param name="varResult" select="$varResult"/></xsl:apply-templates>;
		}
		p_oContext.registerEvent(oEvent);
	</xsl:template>

	<xsl:template match="events">
		<xsl:param name="varResult"/>
		<xsl:text>p_oContext.registerEvent(</xsl:text>
		<xsl:apply-templates select="event[1]">
			<xsl:with-param name="varResult" select="$varResult"/>
		</xsl:apply-templates>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="event">
		<xsl:param name="varResult"/>
		<xsl:text>new </xsl:text><xsl:value-of select="name"/>(this, <xsl:value-of select="$varResult"/><xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="dataloader-impl" mode="set-entity">
		<xsl:param name="varResult"/>
		<xsl:text>BeanLoader.getInstance().getBean(</xsl:text>
		<xsl:value-of select="implements/interface/@name"/>
		<xsl:text>.class)</xsl:text>
		<xsl:choose>
			<xsl:when test="../data-path/full-path-setter">
				<xsl:text>.getData(</xsl:text>
				<xsl:value-of select="implements/interface/@name"/>
				<xsl:text>.DEFAULT_KEY)</xsl:text>
				<xsl:value-of select="substring-before(../data-path/full-path-setter, '(VALUE)')"/>
				<xsl:text>(</xsl:text><xsl:value-of select="$varResult"/><xsl:text>);</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>.addData(</xsl:text>
				<xsl:value-of select="implements/interface/@name"/>
				<xsl:text>.DEFAULT_KEY, </xsl:text>
				<xsl:value-of select="$varResult"/><xsl:text>);</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
	
