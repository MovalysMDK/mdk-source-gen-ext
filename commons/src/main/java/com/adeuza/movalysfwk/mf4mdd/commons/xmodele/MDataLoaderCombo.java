/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.commons.xmodele;

import java.util.ArrayList;
import java.util.List;

import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.a2a.adjava.xmodele.MCascade;
import com.a2a.adjava.xmodele.MDaoInterface;
import com.a2a.adjava.xmodele.MViewModelImpl;

/**
 * <p>Class used to load combo list in MDataLoader class.</p>
 *
 * <p>Copyright (c) 2012</p>
 * <p>Company: Adeuza</p>
 *
 * @author fbourlieux
 * @since MF-Baltoro
 */
public class MDataLoaderCombo  {

	/** node name */
	private final static String NODE_NAME = "combo";
	/** the entity dao interface */
	private MDaoInterface entityDao;
	/** cascade to load the combo */
	private List<MCascade> loadCascade;
	/** view model of the entity */
	private MViewModelImpl entityVM;
	
	/**
	 * Construct a new Combo list loader to generate.
	 */
	public MDataLoaderCombo() {
		loadCascade=new ArrayList<MCascade>();
	}
	
	/**
	 * Set the linked entity. 
	 * @param p_oEntity entity of type <code>MEntityImpl</code>
	 */
	public void setEntityViewModel(MViewModelImpl p_oEntity){
		entityVM=p_oEntity;
	}
	
	/**
	 * Return the <code>ViewModel</code> object of this entity.
	 * @return object <code>MViewModelImpl</code>. It could be null.
	 */
	public MViewModelImpl getEntityViewModel(){
		return entityVM;
	}
	
	/**
	 * Set the <code>entityDao</code> object.
	 * @param p_oEntityDao Objet entityDao
	 */
	public void setEntityDao(MDaoInterface p_oEntityDao) {
		entityDao=p_oEntityDao;
	}
	
	/**
	 * Return the <code>Dao</code> object of this entity.
	 * @return object <code>MDaoInterface</code>. It could be null.
	 */
	public MDaoInterface getEntityDao(){
		return entityDao;
	}
	
	/**
	 * Add a new <code>MCascade</code> to the combo list.
	 * @param p_oCascade cascade used to load data in combo list
	 */
	public void addCascadeToCombo(MCascade p_oCascade){
		if (!loadCascade.contains(p_oCascade)){
			loadCascade.add(p_oCascade);
		}
	}
	
	/**
	 * Add a new list of <code>MCascade</code> to the combo list.
	 * @param p_oCascades cascade list to put in the list
	 */
	public void addCascadeToCombo(List<MCascade> p_oCascades){
		if (p_oCascades != null){
			for (MCascade oTempCascade : p_oCascades){
				addCascadeToCombo(oTempCascade);
			}
		}
	}

	/**
	 * Add to the XML all informations about combo list generation.
	 * @return the xml node that represent the component (type <code>Element</code>)
	 */
	protected Element toXml() {
		String sDaoAttribute = entityVM.getUmlName()+"Dao";
		
		Element r_xMasterElement=DocumentHelper.createElement(NODE_NAME);
			
		r_xMasterElement.addElement("entity").setText(entityVM.getEntityToUpdate().getMasterInterface().getName());
		r_xMasterElement.addElement("entity-attribute-name").setText(entityVM.getUmlName().substring(0,1).toLowerCase()+entityVM.getUmlName().substring(1));
		r_xMasterElement.addElement("entity-getter-name").setText(entityVM.getUmlName());
		if (entityDao != null) {
			r_xMasterElement.addElement("dao-name").setText(entityDao.getName());
			r_xMasterElement.addElement("dao-attribute-name").setText(sDaoAttribute.substring(0,1).toLowerCase()+sDaoAttribute.substring(1));
			r_xMasterElement.addElement("dao-impl-name").setText(entityDao.getMEntityImpl().getName());
			r_xMasterElement.addElement("entity-synchronizable").setText( String.valueOf(entityDao.getMEntityImpl().hasStereotype("Mm_synchronizable") ));
		}
		if (loadCascade!= null && !loadCascade.isEmpty()){
			Element xCascade =  r_xMasterElement.addElement("cascades");
			for( MCascade oCascade : loadCascade) {
				xCascade.add(oCascade.toXml());
			}
		}
		return r_xMasterElement;
	}
	
}
