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

	<!-- TEMPLATE DE GÉNÉRATION DES MÉTHODES -->
	<xsl:template match="action" mode="generate-methods"/>

	

	<xsl:template match="action[action-type='COMPUTE']" mode="generate-methods">
		<xsl:text>/**&#13;</xsl:text>
		<xsl:text> * {@inheritDoc}&#13;</xsl:text>
		<xsl:text> */&#13;</xsl:text>
		<xsl:text>public NullActionParameterImpl doAction(MContext p_oContext, InParameter p_oParameterIn) {&#13;</xsl:text>
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-load-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
				<xsl:text>//MF_DEV_MANDATORY Change select ...&#13;</xsl:text>
				<xsl:text>return null;&#13;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		<xsl:text>}&#13;</xsl:text>
	</xsl:template>
	
	<xsl:template match="action[action-type='CREATE']" mode="generate-methods">
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected void createData( MContext p_oContext, InDisplayParameter p_oInParameter) {
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-create-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:variable name="factoryname"><xsl:value-of select="./class/pojo-factory-interface/name"/></xsl:variable>
					<xsl:variable name="classinterfacename"><xsl:value-of select="./class/implements/interface/@name"/></xsl:variable>
					<xsl:value-of select="$factoryname"/> oEntityFactory = BeanLoader.getInstance().getBean(<xsl:value-of select="$factoryname"/>.class);
					ViewModelCreator oCreator = (ViewModelCreator) Application.getInstance().getViewModelCreator();
					<xsl:value-of select="$classinterfacename"/> oNewEntity = oEntityFactory.createInstance();
					
					<xsl:for-each select="class/association[@type ='many-to-one' and @relation-owner='true' and @transient='false' and @optional='false']">
					try  {
						<xsl:value-of select="./dao-interface/name"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="./dao-interface/name"/>.class);
						<xsl:value-of select="./interface/name"/> oBeanRef = oDao.get<xsl:value-of select="./interface/name"/>(Long.parseLong(p_oInParameter.getId()), CascadeSet.NONE, p_oContext);
						oNewEntity.<xsl:value-of select="./set-accessor"/>(oBeanRef);
					}catch(DaoException e) {
						p_oContext.getMessages().addMessage(ExtFwkErrors.ActionError);
					}	
					</xsl:for-each>
					
					<xsl:value-of select="./viewmodel/implements/interface/@name"/> oVmPanel = oCreator.create<xsl:value-of select="./viewmodel/implements/interface/@name"/>(oNewEntity);
					// sauvegarde de l'entité pour pouvoir la récupérer à la sauvegarde
					Application.getInstance().setCurrentItem(TODO, oNewEntity);
					
					oVmPanel.setEditable(this.isViewModelEnabled(oVmPanel));
				</xsl:with-param>
			</xsl:call-template>

		}
	</xsl:template>

	<xsl:template match="action[action-type='DELETEDETAIL']" mode="generate-methods">
		<xsl:variable name="classinterfacename" select="./class/implements/interface/@name"/>
		<xsl:variable name="varResult">r_o<xsl:value-of select="$classinterfacename"/>ToDelete</xsl:variable>
		/**
		 * {@inheritDoc}
		 */
		@Override
		public <xsl:value-of select="$classinterfacename"/>
			<xsl:text> deleteData( MContext p_oContext, NullActionParameterImpl p_oInParameter) throws ActionException {&#13;</xsl:text>
			<xsl:value-of select="$classinterfacename"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$varResult"/> = null;
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-delete-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
					try {
						<xsl:variable name="daointerfacename"><xsl:value-of select="./dao-interface/name"/></xsl:variable>

						<xsl:value-of select="$daointerfacename"/> oDao = BeanLoader.getInstance().getBean(<xsl:value-of select="$daointerfacename"/>.class);
						// ancien objet avant modification 
						if (BeanLoader.getInstance().getBean(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.class).getData(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.DEFAULT_KEY) != null) {
							<xsl:value-of select="$varResult"/> = BeanLoader.getInstance().getBean(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.class).getData(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.DEFAULT_KEY)<xsl:value-of select="viewmodel/data-path/full-path"/>;
							if (<xsl:value-of select="$varResult"/> != null) {
								oDao.delete<xsl:value-of select="$classinterfacename"/>(<xsl:value-of select="$varResult"/> , p_oContext);
								}
							}

						<xsl:variable name="entity-updated"><xsl:value-of select="./viewmodel/entity-to-update/full-name"/></xsl:variable>

						<!-- on va mettre à jour le view model parent lié en supprimant l'élément -->
						<xsl:apply-templates select="linked-view-models//subvm/viewmodel[entity-to-update/full-name = $entity-updated]" mode="generate-view-model-creation">
							<xsl:with-param name="linked-object" select="$varResult"/>
						</xsl:apply-templates>
						
						<xsl:variable name="entity-to-update-full-name"><xsl:value-of select="linked-view-models//viewmodel[entity-to-update/full-name = $entity-updated]/../../entity-to-update/full-name"/></xsl:variable>
						<xsl:variable name="access-method-linkedobjet"><xsl:value-of select="class/association[@type-name = $entity-to-update-full-name]/get-accessor"/></xsl:variable>
							
						<xsl:apply-templates select="linked-view-models//viewmodel[entity-to-update/full-name = $entity-to-update-full-name]" mode="generate-view-model-creation">
							<xsl:with-param name="linked-object"><xsl:value-of select="$varResult"/>.<xsl:value-of select="$access-method-linkedobjet"/>()</xsl:with-param>
							<xsl:with-param name="panel-name-suffix">Parent</xsl:with-param>
						</xsl:apply-templates>
						
						<xsl:apply-templates select="linked-view-models//viewmodel[entity-to-update/full-name = $entity-to-update-full-name]" mode="generate-parent-view-model-modification">
							<xsl:with-param name="action-on-list">remove</xsl:with-param>
						</xsl:apply-templates>

						BeanLoader.getInstance().getBean(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.class).addData(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.DEFAULT_KEY, null);
						<xsl:apply-templates select="events">
							<xsl:with-param name="varResult" select="$varResult"/>
						</xsl:apply-templates>
					} catch( DaoException oException ) {
						throw new ActionException(oException);
					}
				</xsl:with-param>
			</xsl:call-template>
			return <xsl:value-of select="$varResult"/>;
		}

		/**
		 * {@inheritDoc}
		 */
		protected void toSynchronize(MContext p_oContext, <xsl:value-of select="class/implements/interface/@name"/>
			<xsl:text> p_oEntity) throws ActionException {&#13;</xsl:text>
		<xsl:call-template name="non-generated-bloc">
			<xsl:with-param name="blocId">method-to-synchronize</xsl:with-param>
			<xsl:with-param name="defaultSource">	
				<xsl:if test="count(class/identifier/attribute) = 1 and ( class/identifier/attribute/@type-name = 'long' or class/identifier/attribute/@type-short-name = 'Long' ) ">
				try {
					MObjectToSynchronizeDao oDao = BeanLoader.getInstance().getBean(MObjectToSynchronizeDao.class);
					if (p_oEntity != null) {
						// Entité précédement créée sur le mobile. Sa suppression doit également vider T_MOBJECTTOSYNCHRONIZE
						if (p_oEntity.<xsl:value-of select="class/identifier/attribute/get-accessor"/>() &lt; 0) {
							SqlDelete oDelete = oDao.getDeleteQuery();
							oDelete.addEqualsConditionToWhere(MObjectToSynchronizeField.OBJECTID, p_oEntity.<xsl:value-of select="class/identifier/attribute/get-accessor"/>(), SqlType.INTEGER);
							oDelete.addEqualsConditionToWhere(MObjectToSynchronizeField.OBJECTNAME, "<xsl:value-of select="class/implements/interface/@full-name"/>", SqlType.VARCHAR);
							oDao.genericDelete(oDelete, p_oContext);
						}
						else {
							MObjectToSynchronize oObject2Synchronize = BeanLoader.getInstance().getBean(MObjectToSynchronizeFactory.class).createInstance();
							oObject2Synchronize.setObjectId(p_oEntity.<xsl:value-of select="class/identifier/attribute/get-accessor"/>());
							oObject2Synchronize.setObjectName("<xsl:value-of select="class/implements/interface/@full-name"/>");
							oDao.saveOrUpdateMObjectToSynchronize(oObject2Synchronize, p_oContext);
						}
					}
				}
				catch (DaoException oDaoException) {
					throw new ActionException(oDaoException);
				}
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	}
	</xsl:template>

	<xsl:template match="action[action-type='DELETEDETAIL' and class/transient = 'true']" mode="generate-methods">
		<xsl:variable name="classinterfacename"><xsl:value-of select="./class/implements/interface/@name"/></xsl:variable>
		<xsl:variable name="varResult">r_o<xsl:value-of select="$classinterfacename"/>ToUpdate</xsl:variable>
		/**
		 * {@inheritDoc}
		 */
		@Override
		protected <xsl:value-of select="$classinterfacename"/> deleteData( MContext p_oContext, NullActionParameterImpl p_oInParameter) throws ActionException {
			<xsl:value-of select="$classinterfacename"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$varResult"/> = null;
			<xsl:call-template name="non-generated-bloc">
				<xsl:with-param name="blocId">method-delete-data</xsl:with-param>
				<xsl:with-param name="defaultSource">
					<xsl:value-of select="$varResult"/> = BeanLoader.getInstance().getBean(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.class).getData(<xsl:value-of select="viewmodel/dataloader-impl/implements/interface/@name"/>.DEFAULT_KEY);
					if (<xsl:value-of select="$varResult"/> != null) {
						<xsl:apply-templates select="./viewmodel" mode="generate-view-model-creation">
							<xsl:with-param name="linked-object" select="$varResult"/>
						</xsl:apply-templates>

						<xsl:apply-templates select="viewmodel/mapping" mode="generate-entity-update">
							<xsl:with-param name="varResult" select="$varResult"/>
						</xsl:apply-templates>

						<xsl:variable name="entity-updated"><xsl:value-of select="./viewmodel/entity-to-update/full-name"/></xsl:variable>
						<xsl:apply-templates select="linked-view-models//subvm/viewmodel[entity-to-update/full-name = $entity-updated]" mode="generate-view-model-creation">
							<xsl:with-param name="linked-object" select="$varResult"/>
						</xsl:apply-templates>

						oVMLinkedPanel.updateFromIdentifiable(<xsl:value-of select="$varResult"/>);
					}
				</xsl:with-param>
			</xsl:call-template>
			return <xsl:value-of select="$varResult"/>;
		}
	</xsl:template>

	<xsl:template match="mapping" mode="generate-entity-update">
		<xsl:param name="varResult"/>

		<xsl:apply-templates select="attribute" mode="generate-entity-update">
			<xsl:with-param name="var-parent-entity" select="$varResult"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="entity" mode="generate-entity-update">
			<xsl:with-param name="var-parent-entity" select="$varResult"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="entity" mode="generate-entity-update">
		<xsl:param name="var-parent-entity">oEntityToUpdate</xsl:param>

		<xsl:variable name="var-entity">
			<xsl:text>o</xsl:text>
			<xsl:value-of select="@type"/>
			<xsl:value-of select="position()"/>
		</xsl:variable>

		<xsl:value-of select="@type"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> = </xsl:text>
		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="getter/@name"/>
		<xsl:text>();&#13;</xsl:text>
		<xsl:text>if (</xsl:text>
		<xsl:value-of select="$var-entity"/>
		<xsl:text> != null) {&#13;</xsl:text>

		<xsl:apply-templates select="attribute" mode="generate-entity-update">
			<xsl:with-param name="var-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="entity" mode="generate-entity-update">
			<xsl:with-param name="var-parent-entity" select="$var-entity"/>
		</xsl:apply-templates>

		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="entity[@mapping-type='vm' or @mapping-type='vm_comboitemselected']" mode="generate-entity-update">
		<xsl:param name="var-parent-entity">oEntityToUpdate</xsl:param>

		<xsl:value-of select="$var-parent-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(null);&#13;</xsl:text>
	</xsl:template>

	<xsl:template match="attribute" mode="generate-entity-update">
		<xsl:param name="var-entity">oEntityToUpdate</xsl:param>

		<xsl:value-of select="$var-entity"/>
		<xsl:text>.</xsl:text>
		<xsl:value-of select="setter/@name"/>
		<xsl:text>(</xsl:text>
		<xsl:value-of select="@initial-value"/>
		<xsl:text>);&#13;</xsl:text>
	</xsl:template>
	
	<!--  permet la génération de la récupération du view model grâce au ViewModelCreator -->
	<xsl:template match="viewmodel" mode="generate-view-model-creation">
		<xsl:param name="linked-object"/>
		<xsl:param name="panel-name-suffix"></xsl:param>
		<xsl:if test="position() = 1">
			<xsl:variable name="sCacheKey">
				<xsl:choose>
					<xsl:when test="type/name='LIST_1'">
						<xsl:text>"</xsl:text>
						<xsl:value-of select="implements/interface/@full-name"/>
						<xsl:text>"</xsl:text>
					</xsl:when>
				
					<xsl:when test="string-length($linked-object) > 0">
						<!-- NOTHING TO DO, the cache key is the VM class. -->
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
		
			// on récupère la vue model parent liée
			<xsl:value-of select="implements/interface/@name"/><xsl:text> </xsl:text>oVMLinkedPanel<xsl:value-of select="$panel-name-suffix"/> = Application.getInstance().getViewModelCreator().getViewModel(
					<xsl:if test="string-length($sCacheKey) &gt; 0"><xsl:value-of select="$sCacheKey"/>, </xsl:if><xsl:value-of select="implements/interface/@name"/>.class);
		</xsl:if>
	</xsl:template>
	
	<!--  permet la génération de la modification d'une view model parent de type liste par l'action sur la liste -->
	<xsl:template match="viewmodel" mode="generate-parent-view-model-modification">
		<xsl:param name="action-on-list"/>
		<xsl:param name="child-panel-name-suffix"></xsl:param>
		<xsl:param name="parent-panel-name-suffix">Parent</xsl:param>
		
		<xsl:if test="position() = 1">
			// on modifie la vue model parent liée
			if ( oVMLinkedPanel<xsl:value-of select="$parent-panel-name-suffix"/> instanceof ExpandableViewModel ) {
				((ExpandableViewModel) oVMLinkedPanel<xsl:value-of select="$parent-panel-name-suffix"/>).getComposite().getList().<xsl:value-of select="$action-on-list"/>(oVMLinkedPanel<xsl:value-of select="$child-panel-name-suffix"/>);
			} else if (oVMLinkedPanel<xsl:value-of select="$parent-panel-name-suffix"/> instanceof ListViewModel ){
				((ListViewModel) oVMLinkedPanel<xsl:value-of select="$parent-panel-name-suffix"/>).getList().<xsl:value-of select="$action-on-list"/>(oVMLinkedPanel<xsl:value-of select="$child-panel-name-suffix"/>);
			}
		</xsl:if>
	</xsl:template>

	
</xsl:stylesheet>
